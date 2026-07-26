# Gemma 3 Prompting Guide & Structural Schemas

## 1. Executive Summary

DiLang utilizes Gemma 3 (4B / 27B GGUF) for offline dialogue roleplay, grammatical error diagnostics, dynamic task generation, and contextual translations. This guide defines prompt structures and structural JSON schemas.

---

## 2. Structural Prompt Template Architecture

All Gemma 3 prompts use Gemma's official control tokens (`<start_of_turn>`, `<end_of_turn>`):

```
<start_of_turn>system
System Directive: You are a strict language learning assistant persona.
Target CEFR: {{target_cefr}}
Target Language: {{target_language}}
System Context: {{system_context_json}}
Grammar Focus Rules: {{grammar_focus}}

Output Requirement: You MUST output ONLY valid JSON matching this schema:
{
  "reply": "string",
  "phonetic_transcription": "string",
  "literal_translation": "string",
  "corrections": [
    {
      "flawed_token": "string",
      "suggested_token": "string",
      "error_type": "ERR_MORPH | ERR_SYNTAX | ERR_SEM",
      "explanation": "string"
    }
  ]
}
<end_of_turn>
<start_of_turn>user
Dialogue History:
{{dialogue_history}}

User Said: {{user_utterance}}
<end_of_turn>
<start_of_turn>model
```

---

## 3. Context Window Management

1. **Sliding Dialogue Window**: Max 6 previous conversation turns ($< 1024$ tokens total) are retained in context to guarantee generation speed on mid-range hardware.
2. **Dynamic Context Compression**: Older dialogue turns are summarized into a concise 2-sentence background vector by the `dilang_memory` system.
3. **GBNF Grammar Constraints**: For zero-error structural JSON, `llama.cpp` inference uses GBNF grammar files to constrain token generation to valid JSON syntax tokens.
