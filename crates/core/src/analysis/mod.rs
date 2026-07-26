//! Language Analysis Engine (Tokenization, Lemma, POS, CEFR Classification)

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TokenAnalysis {
    pub token: String,
    pub lemma: String,
    pub pos: String,        // Noun, Verb, Adjective, Preposition, etc.
    pub cefr_level: String, // A1, A2, B1, B2, C1, C2
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnalyzedSentence {
    pub raw_text: String,
    pub tokens: Vec<TokenAnalysis>,
    pub grammar_rules: Vec<String>,
}

#[derive(Default)]
pub struct LanguageAnalysisEngine;

impl LanguageAnalysisEngine {
    pub fn new() -> Self {
        Self
    }

    pub fn analyze_text(&self, text: &str, target_lang: &str) -> AnalyzedSentence {
        let words: Vec<&str> = text
            .split(|c: char| c.is_whitespace() || c.is_ascii_punctuation())
            .filter(|s| !s.is_empty())
            .collect();

        let mut tokens = Vec::new();
        for word in words {
            let lower = word.to_lowercase();
            let (pos, cefr) = match lower.as_str() {
                "guten" | "tag" | "kaffee" | "wasser" | "danke" | "hallo" => ("noun", "A1"),
                "möchte" | "trinken" | "gehen" | "haben" | "sein" => ("verb", "A1"),
                "bitte" | "ja" | "nein" | "gut" => ("adverb", "A1"),
                _ => ("noun", "A2"),
            };

            tokens.push(TokenAnalysis {
                token: word.to_string(),
                lemma: lower,
                pos: pos.to_string(),
                cefr_level: cefr.to_string(),
            });
        }

        let mut rules = Vec::new();
        if text.contains("möchte") || text.contains("bestellen") {
            rules.push("Modal Verb Word Order".to_string());
        }
        if target_lang == "German" && text.contains("Sie") {
            rules.push("Formal Address Pronoun".to_string());
        }

        AnalyzedSentence {
            raw_text: text.to_string(),
            tokens,
            grammar_rules: rules,
        }
    }
}
