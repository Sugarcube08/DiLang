# DiLang Conversation Engine Specification

## 1. Executive Summary

The DiLang Conversation Engine manages offline conversational roleplay, dialogue turn-taking state machines, real-time grammar/vocab error diagnostic loops, and Qwen3-0.6B prompt template synthesis.

---

## 2. Conversation State Machine

```text
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
     │         │ LLM Turn Generation   │ ◄── Qwen3-0.6B local execution
     │         └───────────┬───────────┘
     │                     │ TTS Synthesis (Piper)
     │                     ▼
     │         ┌───────────────────────┐
     └─────────┤ Character Response UI │
               └───────────────────────┘
```

---

## 3. Roleplay State Machine Architecture

Every scenario is driven by a deterministic Finite State Machine (FSM) backed by Qwen3-0.6B for variable text surface generation.

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

## 4. Qwen3-0.6B Prompt Templates & JSON Output Parsing

All calls to Qwen3-0.6B local LLM (via `llama.cpp` Rust bindings) enforce strict structural schema output via ChatML formatting and GBNF grammars.

### 4.1 System Prompt Template
```text
<|im_start|>system
You are a language tutor acting as {{character_name}} in a {{scenario_name}} scenario.
Current Target CEFR Level: {{target_cefr}}.
Grammar Focus: {{target_grammar_rules}}.
Vocabulary Focus: {{target_vocab_words}}.

Rules:
1. Respond in target language: {{target_language}}.
2. Keep response complexity within {{target_cefr}} parameters.
3. Return strict JSON format with fields: "reply", "phonetic", "detected_errors", "next_state_trigger".
<|im_end|>
<|im_start|>user
History: {{dialogue_history}}
User Said: {{user_speech_text}}
<|im_end|>
<|im_start|>assistant
```

### 4.2 Response Payload Verification Struct (`Rust`)
```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct QwenTurnResponse {
    pub reply: String,
    pub phonetic: Option<String>,
    pub detected_errors: Vec<TurnErrorDiagnostic>,
    pub next_state_trigger: String,
}
```

---

## 5. Asynchronous Feedback Loop

While the user is listening to the AI response, the Conversation Engine dispatches background tasks to `grammar` and `vocabulary` modules to update FSRS memory weights without blocking the conversational flow UI.
