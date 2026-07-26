//! FSRS v4 Spaced Repetition Review Engine

use anyhow::Result;
use chrono::{DateTime, Duration, Utc};
use rusqlite::params;
use tracing::info;
use crate::models::{ReviewCard, Vocabulary};
use crate::storage::schema::get_connection;
use crate::events::{global_event_bus, ReviewEventPayload};

pub trait ReviewEngine: Send + Sync {
    fn schedule_vocab_card(&self, vocab: &Vocabulary) -> Result<ReviewCard>;
    fn fetch_due_cards(&self, limit: usize) -> Result<Vec<ReviewCard>>;
    fn submit_review(&self, card_id: &str, rating: u8) -> Result<ReviewCard>;
}

pub struct FsrsReviewEngine;

impl FsrsReviewEngine {
    pub fn new() -> Self {
        Self
    }

    /// FSRS v4 Next Interval Calculation Formula (in Days)
    pub fn calculate_next_interval(stability: f64, request_retention: f64) -> i64 {
        let interval = (stability * (request_retention.ln() / 0.9f64.ln())).round() as i64;
        interval.max(1)
    }
}

impl ReviewEngine for FsrsReviewEngine {
    fn schedule_vocab_card(&self, vocab: &Vocabulary) -> Result<ReviewCard> {
        info!("Scheduling FSRS review card for vocab: {}", vocab.term);
        let conn = get_connection()?;
        let bus = global_event_bus();

        let card_id = format!("c-{}", uuid::Uuid::new_v4().to_string()[..8].to_string());
        let initial_stability = 1.0f64;
        let initial_difficulty = 5.0f64;
        let due_date = Utc::now() + Duration::days(1);
        let due_str = due_date.to_rfc3339();

        conn.execute(
            r#"INSERT OR IGNORE INTO review_cards (id, vocab_id, stability, difficulty, reps, lapses, due_at)
               VALUES (?1, ?2, ?3, ?4, 0, 0, ?5)"#,
            params![card_id, vocab.id, initial_stability, initial_difficulty, due_str],
        )?;

        let card = ReviewCard {
            id: card_id.clone(),
            vocab_id: vocab.id.clone(),
            stability: initial_stability,
            difficulty: initial_difficulty,
            reps: 0,
            lapses: 0,
            due_at: due_date,
            last_review_at: None,
        };

        let payload = ReviewEventPayload::ReviewScheduled {
            card_id: card_id.clone(),
            due_at: due_str,
        };
        let _ = bus.publish("review", &payload);

        Ok(card)
    }

    fn fetch_due_cards(&self, limit: usize) -> Result<Vec<ReviewCard>> {
        let conn = get_connection()?;
        let now_str = Utc::now().to_rfc3339();
        let mut stmt = conn.prepare("SELECT id, vocab_id, stability, difficulty, reps, lapses, due_at, last_review_at FROM review_cards WHERE due_at <= ?1 LIMIT ?2")?;

        let rows = stmt.query_map(params![now_str, limit as i64], |row| {
            let due_str: String = row.get(6)?;
            let due_at = DateTime::parse_from_rfc3339(&due_str).unwrap_or_default().with_timezone(&Utc);

            let last_str: Option<String> = row.get(7)?;
            let last_review_at = last_str.map(|s| DateTime::parse_from_rfc3339(&s).unwrap_or_default().with_timezone(&Utc));

            Ok(ReviewCard {
                id: row.get(0)?,
                vocab_id: row.get(1)?,
                stability: row.get(2)?,
                difficulty: row.get(3)?,
                reps: row.get(4)?,
                lapses: row.get(5)?,
                due_at,
                last_review_at,
            })
        })?;

        let mut cards = Vec::new();
        for r in rows {
            if let Ok(c) = r {
                cards.push(c);
            }
        }
        Ok(cards)
    }

    fn submit_review(&self, card_id: &str, rating: u8) -> Result<ReviewCard> {
        info!("Submitting FSRS review rating {} for card {}", rating, card_id);
        let conn = get_connection()?;

        let mut card = self.fetch_due_cards(100)?
            .into_iter()
            .find(|c| c.id == card_id)
            .ok_or_else(|| anyhow::anyhow!("Card not found"))?;

        // FSRS Rating Update Formula
        match rating {
            1 => { card.lapses += 1; card.stability = (card.stability * 0.5).max(0.5); } // Again
            2 => { card.stability = card.stability * 1.2; } // Hard
            3 => { card.stability = card.stability * 2.0; } // Good
            4 => { card.stability = card.stability * 3.5; } // Easy
            _ => {}
        }
        card.reps += 1;
        let days = Self::calculate_next_interval(card.stability, 0.9);
        card.due_at = Utc::now() + Duration::days(days);
        card.last_review_at = Some(Utc::now());

        conn.execute(
            "UPDATE review_cards SET stability = ?1, difficulty = ?2, reps = ?3, lapses = ?4, due_at = ?5, last_review_at = ?6 WHERE id = ?7",
            params![card.stability, card.difficulty, card.reps, card.lapses, card.due_at.to_rfc3339(), card.last_review_at.map(|d| d.to_rfc3339()), card_id],
        )?;

        Ok(card)
    }
}
