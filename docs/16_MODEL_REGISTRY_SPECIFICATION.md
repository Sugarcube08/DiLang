# 16. Model Registry & Asset Management Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Model Registry

---

## 1. Model Registry Schema

Every offline AI model asset in DiLang must be registered with an immutable `ModelDescriptor`:

```json
{
  "modelId": "dilang.model.llm.qwen2.5_0.5b",
  "version": "1.0.0",
  "name": "Qwen 2.5 0.5B Instruct",
  "backend": "llama_cpp",
  "format": "GGUF",
  "quantization": "Q4_K_M",
  "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "sizeBytes": 398458880,
  "requiredRamBytes": 629145600,
  "supportedCapabilities": ["chat", "grammar_explain", "translation"],
  "targetLanguages": ["de-DE", "es-ES", "ja-JP", "zh-CN", "en-US"]
}
```

---

## 2. Integrity & Installation Workflow

```
Check Local Model File
  │
  ├── 1. Path Verification (`/models/<model_id>.gguf`)
  ├── 2. SHA256 Checksum Calculation & Validation
  ├── 3. Allocation Authorization from ResourceScheduler
  └── 4. Native Engine Handshake & Memory Load
```
