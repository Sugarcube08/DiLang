# DiLang Localization Guide (i18n & l10n)

## 1. Overview

DiLang supports dynamic multi-script rendering, regional phonetics, and local voice synthesis across target learning languages and UI translations.

---

## 2. UI Translation Infrastructure

- **Flutter ARB Standard**: UI string localization relies on standard Application Resource Bundle (`.arb`) files placed in `apps/dilang_flutter/lib/l10n/`.
- **Key Naming Convention**: `[feature]_[component]_[descriptor]` (e.g., `roleplay_chat_mic_tooltip`).
- **Pluralization & Param Substitution**: Enforced via ICU syntax rules in ARB declarations.

---

## 3. Multi-Script Typography & Layout Strategy

1. **Right-to-Left (RTL) Layout Support**: Arabic, Hebrew, and Persian target interfaces flip grid layout directions automatically using Flutter `Directionality` widgets.
2. **Complex Script Rendering**: Japanese (Kanji + Kana + Furigana), Chinese (Pinyin / Zhuyin annotations), and Devanagari require ruby-text line height expansion ($1.6\times$ default line height).
3. **Dynamic Font Selection**:
   - Latin/Cyrillic: Inter / Roboto.
   - Japanese: Noto Sans JP.
   - Chinese: Noto Sans SC / TC.
   - Arabic: Noto Naskh Arabic.

---

## 4. Voice Model (Piper TTS) Swapping

When switching target language profiles, the Rust audio engine dynamically loads local Piper ONNX voice profiles (`piper_voice_es_ES.onnx`, `piper_voice_ja_JP.onnx`) without restarting the application lifecycle.
