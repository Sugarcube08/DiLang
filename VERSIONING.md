# DiLang Versioning Specification 🏷️

DiLang strictly adheres to **Semantic Versioning 2.0.0 (SemVer)** for all software components, native crates, application builds, and schema specifications.

---

## 📌 Semantic Versioning Overview

Given a version number `MAJOR.MINOR.PATCH`:

- **MAJOR**: Increment when breaking API changes, database schema breaking alterations, or non-backwards-compatible FFI protocol updates are introduced.
- **MINOR**: Increment when new backwards-compatible functionality, model integration backends, or features are added.
- **PATCH**: Increment when backwards-compatible bug fixes or minor performance optimizations are introduced.

Pre-release tags follow the format `MAJOR.MINOR.PATCH-alpha.N`, `MAJOR.MINOR.PATCH-beta.N`, or `MAJOR.MINOR.PATCH-rc.N`.

---

## 📦 Component Versioning Rules

DiLang consists of three distinct versioned layers:

```text
┌─────────────────────────────────────────────────────────────┐
│ 1. Flutter Application Layer (dilang_flutter / pubspec.yaml)│
│    Format: MAJOR.MINOR.PATCH+BUILD_NUMBER                   │
└──────────────────────────────┬──────────────────────────────┘
                               │ FFI Protocol Lock
┌──────────────────────────────▼──────────────────────────────┐
│ 2. Rust Workspace Crates (dilang_core, dilang_inference...) │
│    Format: MAJOR.MINOR.PATCH (Cargo.toml)                   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Manifest Schema Lock
┌──────────────────────────────▼──────────────────────────────┐
│ 3. Language Pack Specification Schema                       │
│    Format: MAJOR.MINOR                                      │
└─────────────────────────────────────────────────────────────┘
```

---

### 1. Flutter Application Versioning (`pubspec.yaml`)

The Flutter application version follows the combined SemVer and build number format specified by Flutter tooling:

```yaml
name: dilang
version: 0.1.0+100
```

- **Version String (`0.1.0`)**: Public facing release version.
- **Build Number (`100`)**: Monotonically increasing integer used by iOS App Store and Google Play Store to identify sequential builds.

---

### 2. Rust Engine Crates Versioning (`Cargo.toml`)

All workspace crates (`dilang_core`, `dilang_inference`, `dilang_storage`, `dilang_sync`, `dilang_bridge`) share a unified workspace versioning scheme defined in the root `Cargo.toml`:

```toml
[workspace.package]
version = "0.1.0"
edition = "2021"
license = "AGPL-3.0-only"
```

- Breaking changes in Rust FFI signatures require a **MAJOR** version bump.
- Internal Rust crate updates that do not alter the `flutter_rust_bridge` interface require only a **MINOR** or **PATCH** bump.

---

### 3. Language Pack Schema Versioning

Language Packs are self-contained archives containing dictionary SQLite databases, GGUF/ONNX model files, and Piper voice models. The manifest `manifest.json` specifies the format version:

```json
{
  "pack_id": "com.dilang.en_es",
  "schema_version": "1.0",
  "target_language": "es",
  "source_language": "en",
  "min_app_version": "0.1.0"
}
```

- **`schema_version` MAJOR (`1.x` -> `2.0`)**: Indicates a breaking change in database tables or model file layout. Older app versions will reject loading packs with incompatible major versions.
- **`schema_version` MINOR (`1.0` -> `1.1`)**: Indicates additive backwards-compatible metadata fields.

---

## 🔄 Database & Migration Compatibility Policy

1. **SQLite Schema Migrations**: SQLite database migrations are handled via versioned Rust migration scripts (`dilang_storage/migrations/V001__init.sql`).
2. **Backwards Migration Guarantee**: Major app updates must include explicit database migration paths for user data. Direct data truncation or destructive table recreation is strictly forbidden.
3. **Deprecation Window**: APIs and language pack features marked as `@deprecated` must remain supported for at least one minor release cycle before removal in the subsequent major release.
