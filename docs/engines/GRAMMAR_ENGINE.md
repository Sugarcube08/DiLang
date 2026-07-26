# DiLang Grammar Engine Specification

## 1. Executive Summary

The DiLang Grammar Engine (`dilang_grammar`) parses natural language utterances, detects structural syntax errors, classifies grammatical slip-ups using a strict taxonomy, and generates rule-based corrective feedback.

---

## 2. Syntax Analysis Architecture

The Grammar Engine utilizes tree-sitter AST parsers coupled with rule-matching patterns to evaluate grammatical correctness deterministically before passing complex edge-cases to Gemma 3.

```
[ User Utterance ]
        │
        ▼
┌───────────────────────────────┐
│ Tree-Sitter AST Syntax Parser │
└───────────────┬───────────────┘
                │ Concrete Syntax Tree (CST)
                ▼
┌───────────────────────────────┐
│ Rule Matcher Engine           │ ◄── (Local Rule Set DB)
└───────────────┬───────────────┘
                │ AST Match Failures / Warnings
                ▼
┌───────────────────────────────┐
│ Diagnostic Classification     │
└───────────────┬───────────────┘
                │ Categorized Error Payload
                ▼
┌───────────────────────────────┐
│ Explanation & Minimal Pair    │ ──► Generated Output
└───────────────┬───────────────┘
```

---

## 3. Error Taxonomy Classification

Grammatical errors are categorized into five distinct classes:

| Class | Category Code | Description | Example |
| :--- | :--- | :--- | :--- |
| **Morphological** | `ERR_MORPH` | Conjugation, declension, agreement mismatch | *He go to school yesterday.* |
| **Syntactic** | `ERR_SYNTAX` | Word order violation, missing required argument | *I like very much football.* |
| **Semantic** | `ERR_SEM` | False friend, incorrect preposition usage | *I am agree with you.* |
| **Pragmatic** | `ERR_PRAG` | Incorrect formality / register level | Using informal *tu* with an official in French |
| **Phonetic** | `ERR_PHON` | Sub-optimal pronunciation detected via Whisper | Mispronouncing vowel lengths |

---

## 4. Rule Engine Specification (`Rust`)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GrammarRule {
    pub rule_id: String,
    pub name: String,
    pub target_language: String,
    pub cefr_level: CefrLevel,
    pub ast_pattern: String, // Tree-sitter query expression
    pub error_class: ErrorClass,
    pub explanation_template: String,
}

pub struct GrammarCheckResult {
    pub is_correct: bool,
    pub errors: Vec<GrammarErrorDiagnostic>,
    pub corrected_sentence: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GrammarErrorDiagnostic {
    pub rule_id: String,
    pub error_class: ErrorClass,
    pub error_span: (usize, usize), // Character offsets
    pub original_text: String,
    pub suggested_fix: String,
    pub explanation: String,
}
```

---

## 5. Minimal Pair & Scaffold Generation

For every identified error, the Grammar Engine constructs a **Minimal Pair**:
1. **Flawed Utterance**: User's original sentence highlighting the exact error span.
2. **Target Utterance**: Corrected sentence preserving user intent.
3. **Contrastive Rule**: Concise 1-sentence rule breakdown explaining *why* the change occurred.
