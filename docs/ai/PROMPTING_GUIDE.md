# Qwen3-0.6B Instruct Prompting Guide & Structural Schemas

## 1. Executive Summary

DiLang utilizes **Qwen3-0.6B Instruct (GGUF)** via `llama.cpp` for offline dialogue roleplay, grammatical explanations, hint generation, story generation, and adaptive responses. Translations are resolved using deterministic linguistic resources via the Translation Provider; Qwen serves solely as an adaptive fallback when constructions cannot be resolved deterministically.

---

## 2. Structural Prompt Template Architecture

All Qwen3-0.6B prompts use standard ChatML control tokens (`<|im_start|>`, `<|im_end|>`):

```text
<|im_start|>system
System Directive: You are a strict language learning assistant persona.
Target CEFR: {{target_cefr}}
Target Language: {{target_language}}
System Context: {{system_context_json}}
Grammar Focus Rules: {{grammar_focus}}

Output Requirement: You MUST output ONLY valid JSON matching this schema:
{
  "reply": "string",
  "phonetic_transcription": "string",
  "explanations": [
    {
      "flawed_token": "string",
      "suggested_token": "string",
      "error_type": "ERR_MORPH | ERR_SYNTAX | ERR_SEM",
      "explanation": "string"
    }
  ]
}
<|im_end|>
<|im_start|>user
Dialogue History:
{{dialogue_history}}

User Said: {{user_utterance}}
<|im_end|>
<|im_start|>assistant
```

---

## 3. Context Window Management

1. **Sliding Dialogue Window**: Max 6 previous conversation turns ($< 1024$ tokens total) are retained in context to guarantee generation speed on mid-range hardware.
2. **Dynamic Context Compression**: Older dialogue turns are summarized into a concise 2-sentence background vector by the memory system.
3. **GBNF Grammar Constraints**: For zero-error structural JSON, `llama.cpp` inference uses GBNF grammar files to constrain token generation to valid JSON syntax tokens.
