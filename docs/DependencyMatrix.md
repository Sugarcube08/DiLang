# DiLang — Dependency Import Matrix

**Version**: 1.0-MATRIX  
**Status**: Frozen & Authoritative (Enforced via Static Analysis)  

---

## 1. Import Permission Matrix

| Module / Layer | May Import | Must Never Import |
| :--- | :--- | :--- |
| **`app`** | `core`, `modules`, `infrastructure`, `shared` | Anything outside `lib/` |
| **`core`** | `dart:*`, `flutter/foundation.dart`, shared primitives | `modules`, `infrastructure` |
| **`onboarding`** | `core`, `shared` | `dashboard`, `conversation`, `learning` |
| **`identity`** | `core`, `shared` | `dashboard`, `conversation` |
| **`dashboard`** | `identity` contracts, `learning` contracts, `shared` | `sqlite`, `ai` |
| **`conversation`** | `learning` contracts, `speech` contracts, `shared` | `sqlite` directly |
| **`learning`** | `core`, `shared` | `widgets` |
| **`knowledge_graph`**| `learning` contracts | `sqlite` directly |
| **`speech`** | runtime contracts | `ai` providers directly |
| **`settings`** | runtime contracts | `sqlite` directly |
| **`infrastructure`**| `core` only | `feature modules` |
| **`shared`** | `core` | `feature modules` |

---

## 2. Enforcement Guidelines

- **No Lateral Feature Imports**: Feature modules under `modules/` MUST NOT import each other's implementation files directly. Communication is routed through `DiLangRuntime` or `EventBus`.
- **Infrastructure Isolation**: `infrastructure/` implements low-level drivers and MUST NEVER depend on `modules/`.
- **Core Independence**: `core/` contains pure Dart/Flutter abstractions and primitives; it MUST NEVER depend on `infrastructure/` or `modules/`.
