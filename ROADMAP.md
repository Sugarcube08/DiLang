# High-Level Product & Technical Roadmap — DiLang

This document provides a strategic view of major platform milestones. For granular implementation phase tracking, see [04_PHASES.md](docs/04_PHASES.md).

---

## 🎯 Milestone 1: Platform Foundation & Pure Domain Core (Current)
- [x] Contract-first specification suite (`/docs/01` - `13`).
- [x] Pure Dart Core Kernel package (`packages/core`).
- [x] Language Intelligence domain package (`packages/language`).
- [x] Learner state & knowledge graph package (`packages/learner`).
- [x] Human Memory Engine package (`packages/memory`).
- [x] Monorepo governance & CI infrastructure setup.

---

## 🚀 Milestone 2: Native AI Infrastructure & Storage Engine (Next)
- [ ] Build C++ dynamic wrappers (`libdilang_llama`, `libdilang_whisper`, `libdilang_piper`).
- [ ] Implement `packages/native_bridge` dart:ffi dynamic library bindings.
- [ ] Implement `packages/storage` Drift SQLite Event Store & Projection tables.
- [ ] Prototype local model loader and SHA256 integrity manager.

---

## 🌐 Milestone 3: Learning Engine & Local Sync Protocol
- [ ] Learning Engine orchestration (`packages/learning_engine`).
- [ ] Local-first peer-to-peer sync engine (`packages/sync`) with Protobuf & LZ4 compression.
- [ ] Multimodal exercise generation contracts.

---

## 🎨 Milestone 4: Multi-Platform UI & Interactive Design System
- [ ] Flutter Design System package (`packages/design_system`).
- [ ] Cross-platform desktop (Linux/Windows/macOS) and mobile (Android/iOS) applications in `apps/`.
