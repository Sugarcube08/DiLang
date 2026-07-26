# DiLang Conversation Engine Specification

## 1. Executive Summary

The DiLang Conversation Engine (`dilang_conversation`) manages offline conversational roleplay, dialogue turn-taking state machines, real-time grammar/vocab error diagnostic loops, and Gemma 3 prompt template synthesis.

---

## 2. Conversation State Machine

```
               ┌───────────────────────┐
               │    Initialization     │
               └───────────┬───────────┘
                           │ Load Scenario & Character
                           ▼
               ┌───────────────────────┐
     ┌────────►│   User Input Audio    │
     │         └───────────┬───────────┘
     │                     │ STT Transcribe (Whisper)
     │                     ▼
     │         ┌───────────────────────┐
     │         │ Diagnostic Evaluation │ ◄── Parallel Grammar/Vocab Check
     │         └───────────┬───────────┘
     │                     │ Injected Feedback State
     │                     ▼
     │         ┌───────────────────────┐
     │         │ LLM Turn Generation   │ ◄── Gemma 3 local execution
     │         └───────────┬───────────┘
     │                     │ TTS Synthesis (Piper)
     │                     ▼
     │         ┌───────────────────────┐
     └─────────┤ Character Response UI │
               └───────────────────────┘
```

---

## 3. Roleplay State Machine Architecture

Every scenario is driven by a deterministic Finite State Machine (FSM) backed by Gemma 3 for variable text surface generation.

### 3.1 Scenario Definition Schema
```json
{
  "scenario_id": "bakery_ordering_a2",
  "target_cefr": "A2",
  "initial_state": "greeting",
  "states": {
    "greeting": {
      "system_prompt": "You are a baker in Paris. Greet the customer warmly and ask what they would like.",
      "transitions": [
        { "condition": "user_mentions_pastry", "next_state": "confirm_quantity" },
        { "condition": "user_asks_recommendation", "next_state": "give_recommendation" }
      ]
    },
    "confirm_quantity": {
      "system_prompt": "Ask the user how many items they want.",
      "transitions": [
        { "condition": "quantity_provided", "next_state": "payment" }
      ]
    }
  }
}
```

---

## 4. Gemma 3 Prompt Templates & JSON Output Parsing

All calls to Gemma 3 local LLM (via `llama.cpp` Rust bindings) enforce strict structural schema output via GBNF grammars or strict JSON system instructions.

### 4.1 System Prompt Template
```
<start_of_turn>system
You are a language tutor acting as {{character_name}} in a {{scenario_name}} scenario.
Current Target CEFR Level: {{target_cefr}}.
Grammar Focus: {{target_grammar_rules}}.
Vocabulary Focus: {{target_vocab_words}}.

Rules:
1. Respond in target language: {{target_language}}.
2. Keep response complexity within {{target_cefr}} parameters.
3. Return strict JSON format with fields: "reply", "phonetic", "translation", "detected_errors", "next_state".
<end_of_turn>
<start_of_turn>user
History: {{dialogue_history}}
User Said: {{user_speech_text}}
<end_of_turn>
<start_of_turn>model
```

### 4.2 Response Payload Verification Struct (`Rust`)
```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GemmaTurnResponse {
    pub reply: String,
    pub phonetic: Option<String>,
    pub translation: String,
    pub detected_errors: Vec<TurnErrorDiagnostic>,
    pub next_state_trigger: String,
}
```

---

## 5. Asynchronous Feedback Loop

While the user is listening to the AI response, the Conversation Engine dispatches background tasks to `dilang_grammar` and `dilang_vocab` to update FSRS memory weights without blocking the conversational flow UI.
