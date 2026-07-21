# 12. Language Domain & Data Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Language Domain

---

## 1. Domain Separation Directive

DiLang enforces a strict boundary between **Language Data** (Immutable target language facts) and **Learner State** (Evolving user memory graphs):

```
 +-------------------------------------+         +-------------------------------------+
 |         LANGUAGE DOMAIN             |         |           LEARNER DOMAIN            |
 |  Immutable Linguistic Knowledge     |         |   Evolving User Mastery State       |
 |  - Dictionary Entries & Lemmata     |  VS     |   - Item Stability (S)              |
 |  - Morphological Paradigms          |         |   - Item Difficulty (D)             |
 |  - Phrase Graphs & Intents          |         |   - Review Intervals & History      |
 +-------------------------------------+         +-------------------------------------+
```

Language data is independent of any specific learner or AI model. Adding or extending a language requires providing compliant data structures without altering application logic.

---

## 2. ISO & BCP-47 Locale Identifiers

DiLang uses standard BCP-47 language tags for locale resolution:

| Language Tag | ISO 639-1 | Writing System | Morphological Type | Example Supported Targets |
| :--- | :--- | :--- | :--- | :--- |
| `de-DE` | `de` | Latin | Fusional / Compound | German (Standard) |
| `es-ES` | `es` | Latin | Fusional | Spanish (Castilian) |
| `ja-JP` | `ja` | Kanji / Kana | Agglutinative | Japanese |
| `zh-CN` | `zh` | Simplified Han | Isolating | Mandarin Chinese |
| `ar-SA` | `ar` | Arabic | Root-and-Pattern | Arabic (Modern Standard) |

---

## 3. Canonical Vocabulary Data Architecture

A vocabulary item in DiLang is a structured relational entity, not a flat text string.

```
                  +--------------------------------+
                  |        VocabularyEntry         |
                  +--------------------------------+
                                  |
            +---------------------+---------------------+
            |                     |                     |
            v                     v                     v
     +--------------+     +---------------+     +---------------+
     |    Lemma     |     | Surface Forms |     | Pronunciation |
     |  (Base Form) |     | (Inflections) |     |  (IPA / Audio)|
     +--------------+     +---------------+     +---------------+
            |                     |                     |
            +---------------------+---------------------+
                                  |
            +---------------------+---------------------+
            |                     |                     |
            v                     v                     v
     +--------------+     +---------------+     +---------------+
     |  GrammarTags |     | Semantic Graph|     |  CEFR Level   |
     | (POS, Gender)|     | (Syn/Ant/Rel) |     |  (A1 - C2)    |
     +--------------+     +---------------+     +---------------+
```

---

## 4. Reusable Grammar Rule Taxonomy

Languages construct their grammar graphs using reusable grammatical rule primitives:

- **Case Systems**: Nominative, Accusative, Dative, Genitive, Ergative.
- **Agreement**: Subject-Verb, Noun-Adjective gender/number agreement.
- **Syntactic Word Order**: SVO, SOV, V2 (Verb-Second), VSO.
- **Inflection Types**: Conjugation (Verbs), Declension (Nouns/Adjectives), Comparison (Adjectives).

---

## 5. Phrase Graph & Intent Specification

Conversational fluidity relies on the **Phrase Graph**, which connects natural expressions by communicative intent:

```
Intent: ORDER_FOOD_AT_RESTAURANT
 ├── Phrase: "Ich hätte gerne einen Kaffee." (Formality: Polite / Standard)
 ├── Phrase: "Ein Kaffee, bitte." (Formality: Informal / Short)
 ├── Phrase: "Bring mir Kaffee." (Formality: Rude / Direct -> Common Error Trigger)
 └── Variants: [Kaffee, Tee, Wasser, Espresso]
```
