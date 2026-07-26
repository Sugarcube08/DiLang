# DiLang Release Process & Build Pipeline 📦

This document defines the official release engineering process, release candidate (RC) validation, and multi-platform build pipeline for **DiLang**.

---

## 📅 Release Cycle & Stages

DiLang follows a structured release lifecycle:

```text
  [Development Branch main]
             │
             ▼
    [release/vX.Y.Z Branch] ──► Release Candidate Tag (vX.Y.Z-rc.N)
             │                         │
             │                         ▼
             │                Automated QA & Manual Verification
             │                         │
             ▼                         ▼
      [Tag vX.Y.Z] ◄────────────── Passed RC Checks
             │
             ▼
  Production Artifact Packaging & Signed Release
```

1. **Alpha / Beta Releases**: Fast-iterating feature releases tagged as `vX.Y.Z-alpha.N` or `vX.Y.Z-beta.N`.
2. **Release Candidate (RC)**: Feature-locked builds tagged as `vX.Y.Z-rc.N` created from `release/vX.Y.Z` branches.
3. **Stable Release**: GA build tagged as `vX.Y.Z` after RC verification passes cleanly.

---

## ✅ Pre-Release Checklist

Before creating a release tag, maintainers must verify:

- [ ] All CI checks pass on `main` without warning or failure (`.github/workflows/ci.yml`).
- [ ] `CHANGELOG.md` is updated with all breaking changes, features, and fixes under the new version header.
- [ ] Version numbers in `pubspec.yaml` (Flutter) and `Cargo.toml` (Rust crates) match the target release.
- [ ] `flutter_rust_bridge_codegen` bindings are regenerated and verified up-to-date.
- [ ] Security audit check (`cargo audit`) reports 0 known unpatched vulnerabilities.
- [ ] Model hashes and default Language Pack manifests are verified.

---

## 🏗️ Binary Build Pipeline

Because DiLang combines a Flutter frontend with a native Rust engine and compiled C/C++ inference backends (`llama.cpp`, `whisper.cpp`, `piper`), native targets must be cross-compiled before packaging.

### Target Triples Summary

| Target Platform | Rust Target Triple | Output Artifact |
| --------------- | ------------------ | --------------- |
| Android (ARM64) | `aarch64-linux-android` | `libdilang_engine.so` |
| Android (x86_64)| `x86_64-linux-android`  | `libdilang_engine.so` |
| iOS (ARM64)     | `aarch64-apple-ios`     | `libdilang_engine.a` (Static framework) |
| macOS (Universal)| `aarch64-apple-darwin` / `x86_64-apple-darwin` | `libdilang_engine.dylib` |
| Linux (x86_64)  | `x86_64-unknown-linux-gnu` | `libdilang_engine.so` |
| Windows (x86_64)| `x86_64-pc-windows-msvc`   | `dilang_engine.dll` |

---

### Step-by-Step Build Commands

#### 1. Rust Engine Compilation
```bash
# Build release binaries across workspace
cargo build --workspace --release

# Cross-compile for mobile targets (example: Android ARM64)
cargo build --target aarch64-linux-android --release -p dilang_bridge
```

#### 2. Cross-Language Bindings Check
```bash
flutter_rust_bridge_codegen generate
```

#### 3. Flutter Application Packaging

- **Android (APK & App Bundle)**:
  ```bash
  flutter build apk --release --split-per-abi
  flutter build appbundle --release
  ```

- **iOS (IPA)**:
  ```bash
  flutter build ipa --release --export-options-plist=ios/exportOptions.plist
  ```

- **Linux (AppImage / Tarball)**:
  ```bash
  flutter build linux --release
  ```

- **macOS (Bundle / DMG)**:
  ```bash
  flutter build macos --release
  ```

- **Windows (Executable / MSI)**:
  ```bash
  flutter build windows --release
  ```

---

## 🔒 Artifact Verification & Signing

All production binaries attached to GitHub Releases must be cryptographically signed and accompanied by a checksum file.

1. **Generate SHA-256 Checksums**:
   ```bash
   sha256sum DiLang-*.apk DiLang-*.ipa DiLang-*.AppImage > CHECKSUMS.txt
   ```

2. **GPG Sign Release Artifacts**:
   ```bash
   gpg --detach-sign --armor CHECKSUMS.txt
   ```

3. **Publishing**:
   Release artifacts (`.apk`, `.aab`, `.ipa`, `.dmg`, `.AppImage`, `.zip`), `CHECKSUMS.txt`, and `CHECKSUMS.txt.asc` are uploaded directly to the GitHub Release entry.
