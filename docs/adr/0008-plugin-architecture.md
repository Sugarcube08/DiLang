# ADR-0008: Language Pack & Scenario Plugin Architecture

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
DiLang must support community-authored language packs, custom roleplay scenario scripts, tree-sitter grammar rules, and Piper voice models without requiring core application re-compilation.

---

## Decision Drivers
- Modularity and extensibility.
- Strict sandboxing of third-party content files.
- Single file bundle format (`.dilangpack` / `.zip`) containing JSON manifests, audio samples, and rules.

---

## Decision
Design a **Plugin Architecture** in `crates/dilang_plugin`. Plugins are packaged as verified `.dilangpack` ZIP archives containing a `manifest.json`, scenario FSM definitions, Piper voice models, and Tree-Sitter grammar query files.

---

## Consequences
### Positive:
- Enables community contribution of new target language packs and roleplay scenarios.
- Plugins remain completely offline and local to the user's file system.

### Negative:
- Plugin manifest schema validation required to prevent malformed rule ingestion.
