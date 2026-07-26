//! Real User Repository SQLite Implementation

use crate::models::User;
use crate::storage::schema::get_connection;
use anyhow::Result;
use rusqlite::params;
use tracing::info;

pub trait UserRepositoryContract: Send + Sync {
    fn create_user(&self, username: &str, native_lang: &str, target_lang: &str) -> Result<User>;
    fn save_user_profile(
        &self,
        user_id: &str,
        avatar: &str,
        age: Option<u32>,
        country: &str,
        timezone: &str,
    ) -> Result<()>;
    fn save_learning_goal(&self, user_id: &str, daily_minutes: u32, daily_cards: u32)
        -> Result<()>;
    fn get_active_user(&self) -> Result<Option<User>>;
}

#[derive(Default)]
pub struct UserRepositoryImpl;

impl UserRepositoryImpl {
    pub fn new() -> Self {
        Self
    }
}

impl UserRepositoryContract for UserRepositoryImpl {
    fn create_user(&self, username: &str, native_lang: &str, target_lang: &str) -> Result<User> {
        let conn = get_connection()?;
        let active = self.get_active_user()?;

        if let Some(mut existing) = active {
            info!(
                "Updating existing active user in SQLite: id={}, username='{}', native='{}', target='{}'",
                existing.id, username, native_lang, target_lang
            );
            if !username.is_empty() {
                existing.username = username.to_string();
            }
            if !native_lang.is_empty() {
                existing.native_language = native_lang.to_string();
            }
            if !target_lang.is_empty() {
                existing.target_language = target_lang.to_string();
            }

            conn.execute(
                "UPDATE users SET username = ?1, native_language = ?2, target_language = ?3 WHERE id = ?4",
                params![existing.username, existing.native_language, existing.target_language, existing.id],
            )?;

            Ok(existing)
        } else {
            info!("Inserting initial user into SQLite database: {}", username);
            let user = User::new(username, native_lang, target_lang);
            conn.execute(
                "INSERT INTO users (id, username, native_language, target_language, created_at) VALUES (?1, ?2, ?3, ?4, ?5)",
                params![user.id, user.username, user.native_language, user.target_language, user.created_at.to_rfc3339()],
            )?;
            Ok(user)
        }
    }

    fn save_user_profile(
        &self,
        user_id: &str,
        avatar: &str,
        age: Option<u32>,
        country: &str,
        timezone: &str,
    ) -> Result<()> {
        info!("Updating user profile in SQLite for user: {}", user_id);
        let conn = get_connection()?;

        conn.execute(
            "INSERT OR REPLACE INTO user_profiles (user_id, avatar, age, country, timezone) VALUES (?1, ?2, ?3, ?4, ?5)",
            params![user_id, avatar, age, country, timezone],
        )?;

        Ok(())
    }

    fn save_learning_goal(
        &self,
        user_id: &str,
        daily_minutes: u32,
        daily_cards: u32,
    ) -> Result<()> {
        info!("Saving learning goal in SQLite for user: {}", user_id);
        let conn = get_connection()?;

        conn.execute(
            "INSERT OR REPLACE INTO learning_goals (user_id, target_daily_minutes, target_daily_cards, current_streak_days) VALUES (?1, ?2, ?3, 0)",
            params![user_id, daily_minutes, daily_cards],
        )?;

        Ok(())
    }

    fn get_active_user(&self) -> Result<Option<User>> {
        let conn = get_connection()?;
        let mut stmt = conn.prepare(
            "SELECT id, username, native_language, target_language, created_at FROM users LIMIT 1",
        )?;
        let user_opt = stmt.query_row([], |row| {
            let created_str: String = row.get(4)?;
            let created_at = chrono::DateTime::parse_from_rfc3339(&created_str)
                .unwrap_or_default()
                .with_timezone(&chrono::Utc);
            Ok(User {
                id: row.get(0)?,
                username: row.get(1)?,
                native_language: row.get(2)?,
                target_language: row.get(3)?,
                created_at,
            })
        });

        match user_opt {
            Ok(user) => Ok(Some(user)),
            Err(rusqlite::Error::QueryReturnedNoRows) => Ok(None),
            Err(e) => Err(e.into()),
        }
    }
}
