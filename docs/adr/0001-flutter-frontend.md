# ADR-0001: Adopt Flutter for Multi-Platform Native Frontend

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
DiLang requires a unified frontend UI codebase capable of compiling to high-performance native desktop (macOS, Linux, Windows) and mobile targets (Android, iOS). The frontend must deliver 60/120 FPS glassmorphic visuals, dynamic speech waveform canvas rendering, and low-overhead inter-process communication with native Rust binaries.

---

## Decision Drivers
- High rendering performance (Flutter Impeller/Skia engine rendering directly to Metal/Vulkan).
- Single Dart codebase target for 5 operating systems.
- Robust ecosystem for dynamic layout, haptics, and custom vector canvases.
- High-level FFI interop support with Rust via `flutter_rust_bridge`.

---

## Decision
Adopt **Flutter (3.x / Dart 3.x)** as the sole presentation framework for DiLang v2. Flutter will strictly act as a view layer; all business logic, SQLite interaction, and AI execution will reside in the Rust core backend.

---

## Consequences
### Positive:
- Single codebase reduces cross-platform UI maintenance effort by ~70%.
- Pixel-perfect consistency across macOS, Windows, Linux, Android, and iOS.
- Impeller rendering engine guarantees smooth frame rates without UI thread micro-stutters.

### Negative:
- Initial desktop binary size overhead (~30-40 MB bundle base).
- Strict separation required to prevent developers from writing business logic directly in Dart.
