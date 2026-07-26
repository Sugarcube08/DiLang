# DiLang Dynamic Plugin Architecture Specification 🧩

> **Notice**: This root document is an alias to the primary plugin specification located at [`docs/architecture/PLUGIN_SYSTEM.md`](docs/architecture/PLUGIN_SYSTEM.md).

For full details on the dual-tier WASM (Wasmtime) vs Native C-ABI execution model, plugin manifests (`dilang-plugin.toml`), extension hooks (Dictionary, Tokenizer, Grammar, SRS), and WASI sandbox capability restrictions, please refer directly to:

👉 **[Primary Plugin System Documentation (`docs/architecture/PLUGIN_SYSTEM.md`)](docs/architecture/PLUGIN_SYSTEM.md)**

---

## Plugin System Summary

- **Execution Tiers**: Tier 1 WASM Sandbox (Wasmtime for untrusted community plugins) & Tier 2 Native Dynamic Library Interface.
- **Manifest**: `dilang-plugin.toml` specifying permissions, entrypoint, ABI target, and capabilities.
- **Extension Hooks**: Tokenizers, Morphological Analyzers, Grammar Generators, Dictionary Parsers, SRS Schedulers.
- **Security Isolation**: WASI capabilities (no default network, isolated filesystem sandbox, 64MB RAM cap, CPU fuel limits).
