# DiLang — Development Guide

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Prerequisites

- **Flutter SDK**: `>= 3.24.0`
- **Dart SDK**: `>= 3.5.0`
- **SQLite**: System `sqlite3` dynamic library (`libsqlite3.so.0` on Linux, `sqlite3.dll` on Windows, `libsqlite3.dylib` on macOS).

---

## 2. Running Locally

```bash
# Fetch dependencies
flutter pub get

# Run static analysis
flutter analyze .

# Run test suite
flutter test

# Launch Desktop application
flutter run -d linux
```
