# DiLang Build & Release Guide

**Target Platforms:** Linux Desktop & Android Mobile  
**Build Tool:** Flutter CLI

---

## 1. Linux Desktop Build Matrix

To build the release binary for Linux:

```bash
cd apps/desktop
flutter build linux --release
```

Output binary: `apps/desktop/build/linux/x64/release/bundle/dilang_desktop`

## 2. Android Mobile Build Matrix

To build the APK or App Bundle for Android:

```bash
cd apps/desktop # (or apps/mobile)
flutter build apk --release
```

## 3. Build Matrix Verification Criteria

- [x] Zero analyzer warnings (`flutter analyze`)
- [x] Clean compilation without FFI dynamic library errors
- [x] All 20+ test suites passing (`dart test`)
