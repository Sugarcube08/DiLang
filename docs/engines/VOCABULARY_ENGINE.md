# DiLang Vocabulary Engine Specification

## 1. Executive Summary

The DiLang Vocabulary Engine (`dilang_vocab`) provides language-agnostic tokenization, morphological analysis, frequency rank scoring, CEFR tagging, and real-time context extraction from natural conversation and import texts.

---

## 2. Tokenization Architecture

Because DiLang supports target languages across multiple scripts (Latin, Cyrillic, CJK, Semitic), tokenization is modularized into pluggable Rust tokenizers:

```
┌─────────────────────────────────────────────────────────────┐
│                      VocabTokenizer                         │
└──────┬──────────────────────┬───────────────────────┬───────┘
       │                      │                       │
       ▼                      ▼                       ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────────┐
│ Unicode/ BPE │      │  Sudachi-RS  │      │     Jieba-RS     │
│ (Latin/En/Es)│      │  (Japanese)  │      │    (Chinese)     │
└──────────────┘      └──────────────┘      └──────────────────┘
```

### 2.1 Tokenizer Trait Contract (`Rust`)
```rust
pub trait MorphologicalTokenizer: Send + Sync {
    fn tokenize(&self, text: &str) -> Result<Vec<TokenLemma>, VocabError>;
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TokenLemma {
    pub surface: String,
    pub lemma: String,
    pub pos_tag: String, // Part of speech (Noun, Verb, Adjective, etc.)
    pub start_offset: usize,
    pub end_offset: usize,
}
```

---

## 3. CEFR Tagging & Frequency Lists

Every lemma in the local vocabulary database is indexed with frequency metrics and CEFR levels.

### 3.1 Frequency Matrix
- **Zipf Scale**: Calculated as $Z = \log_{10}(\text{frequency\_per\_million}) + 3$.
- **CEFR Mapping Table**:
  - **A1**: Top 1,000 highest Zipf score lemmas ($Z \ge 6.0$).
  - **A2**: Top 1,001 – 2,500 lemmas ($5.2 \le Z < 6.0$).
  - **B1**: Top 2,501 – 5,000 lemmas ($4.5 \le Z < 5.2$).
  - **B2**: Top 5,001 – 10,000 lemmas ($3.8 \le Z < 4.5$).
  - **C1**: Top 10,001 – 20,000 lemmas ($3.0 \le Z < 3.8$).
  - **C2**: Specialized / Low-frequency lemmas ($Z < 3.0$).

---

## 4. Context Extraction Pipeline

When a user encounters a new vocabulary word during a dialogue turn, the engine automatically extracts sentence context:

```rust
pub struct VocabContextExtractor;

impl VocabContextExtractor {
    pub fn extract_collocations(sentence: &str, target_lemma: &str) -> Vec<String> {
        // Extracts n-gram collocations (target word +/- 3 tokens)
        // Returns clean example usage snippets
    }
}
```

### 4.1 Automated Flashcard Generation
Extracted tokens with missing user FSRS cards automatically spawn draft cards in SQLite with:
1. Target Lemma & Lemma POS
2. Audio Pronunciation Key (Piper TTS pre-rendered or synthesized on demand)
3. Sentence Context & Machine Translation
4. Initial FSRS Stability $S_0 = 1.0$ day.
