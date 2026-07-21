# 11. Core Platform Specification & Phase 0 Architecture — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Phase 0

---

## 1. Monorepo Directory Architecture

DiLang is structured as a single monorepo to ensure tight contract enforcement, shared build pipelines, and atomic cross-package commits.

```text
dilang/
├── apps/
│   ├── mobile/             # Flutter Android/iOS entrypoint
│   ├── desktop/            # Flutter Linux/Windows/macOS entrypoint
│   └── web/                # Future Web entrypoint
│
├── packages/
│   ├── core/               # Pure Dart Core Kernel (No Flutter dependency)
│   │   ├── kernel/         # Core Kernel orchestrator & SystemBootstrapper
│   │   ├── event_bus/      # Async Event Bus & Domain Event contracts
│   │   ├── lifecycle/      # ModuleLifecycle & LifecycleManager
│   │   ├── plugin_system/  # PluginManifest & PluginManager
│   │   ├── capability_registry/ # Service & Capability Registry
│   │   ├── configuration/  # Core Configuration Loader
│   │   ├── diagnostics/    # System Diagnostics & Telemetry
│   │   ├── logger/         # Platform Logger
│   │   └── errors/         # Core Error Taxonomy
│   │
│   ├── domain/             # Pure Dart Entities, Invariants & Aggregates
│   ├── learner/            # Learner Graph & FSRS-4.5 calculation engine
│   ├── language/           # Language packs & morphological contracts
│   ├── conversation/       # Dialogue state machine & turn manager
│   ├── grammar/            # Syntactic analyzer & error classification
│   ├── vocabulary/         # Lexical unit repository & SRS queues
│   ├── pronunciation/      # Audio alignment & phonetic evaluator
│   ├── review/             # Multimodal exercise orchestration
│   ├── ai_runtime/         # Local AI provider implementations
│   ├── storage/            # Drift SQLite Event Store & Projections
│   ├── sync/               # Protobuf LZ4 gRPC synchronization
│   ├── native_bridge/      # dart:ffi C/C++ bindings wrapper
│   └── design_system/      # Flutter visual design tokens & widgets
│
├── native/
│   ├── android/            # Native C++ CMake scripts for Android
│   ├── linux/              # Native C++ CMake scripts for Linux
│   ├── windows/            # Native C++ CMake scripts for Windows
│   └── shared/             # C Headers (dilang_llama.h, etc.)
│
├── protos/                 # Protocol Buffer schema source files (.proto)
├── docs/                   # Complete Platform & Architectural Specs (01-11)
└── tools/                  # Code gen, build scripts, CLI test harnesses
```

---

## 2. Plugin Manifest Specification

Every extension or runtime module in DiLang must declare its capabilities, platform target, and version dependencies using a standardized `PluginManifest`.

```yaml
id: dilang.plugin.ai.llm.qwen
version: 1.0.0
name: Qwen 2.5 0.5B Local LLM Runtime
author: DiLang Platform Team
capabilities:
  - chat
  - grammar_explanation
  - translation
  - vocabulary_extraction
platforms:
  - android
  - linux
  - windows
  - macos
dependencies:
  - id: dilang.plugin.native.llama_cpp
    version: ">=1.0.0"
priority: 10
```

---

## 3. Capability Registry & Service Discovery

Application features do **not** invoke specific implementations directly. All operations query the `CapabilityRegistry`.

```dart
// Resolution Pattern
final llm = CapabilityRegistry.instance.resolve<LanguageModelCapability>();
await llm.generateCompletion(prompt: "Explain German word order.");
```

---

## 4. Module Lifecycle Contract

Every stateful domain, infrastructure, or plugin module must implement the standard `ModuleLifecycle` interface.

```
+---------------+      initialize()     +---------------+      start()     +---------------+
|  UNINITIALIZED| --------------------> |   INITIALIZED | --------------> |    RUNNING    |
+---------------+                       +---------------+                 +---------------+
                                                ^                                |
                                       stop()   |           pause()              |
                                                +--------------------------------+
                                                                                 |
                                                                                 v
                                                                          +---------------+
                                                                          |    PAUSED     |
                                                                          +---------------+
                                                                                 | resume()
                                                                                 v
                                                                          +---------------+
                                                                          |    RUNNING    |
                                                                          +---------------+
                                                                                 | dispose()
                                                                                 v
                                                                          +---------------+
                                                                          |   DISPOSED    |
                                                                          +---------------+
```

---

## 5. System Bootstrapper Pipeline

The UI is **the final step** in startup, ensuring that state, storage, capabilities, and native runtimes are completely initialized and healthy prior to presenting screens.

```text
Boot Phase
  │
  ├── 1. Platform Configuration (Config files, env parameters)
  ├── 2. Logger & Diagnostics (File logger, telemetry sinks)
  ├── 3. Native Runtime Loader (Load dynamic C++ libraries)
  ├── 4. Plugin Discovery & Manifest Verification
  ├── 5. Capability Registry Setup
  ├── 6. Storage & Event Store Connection (Drift WAL mode)
  ├── 7. Event Bus Activation
  ├── 8. Domain Modules Initialization (FSRS, Learner Graph)
  ├── 9. Application Modules Start
  └── 10. UI App Render (Flutter runApp)
```

---

## 6. Error Taxonomy Hierarchy

Arbitrary exceptions are strictly prohibited. All failures in DiLang extend from `PlatformException`.

```text
PlatformException
├── AIException
│   ├── ModelNotFoundException
│   ├── ContextWindowExceededException
│   └── InferenceFailedException
├── StorageException
│   ├── DatabaseCorruptException
│   └── EventAppendFailedException
├── SyncException
│   ├── ConflictResolutionFailedException
│   └── TransportFailedException
├── RuntimeException
│   └── FfiLibraryLoadException
├── AudioException
│   └── MicrophonePermissionDeniedException
├── ConfigurationException
└── PluginException
    ├── PluginDependencyMissingException
    └── ManifestInvalidException
```
