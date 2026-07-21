# DiLang Development Guide

**Target Platforms:** Linux Desktop (`apps/desktop`) & Android (`apps/mobile`)  
**Package Manager:** Melos  
**Language/SDK:** Dart 3.5+, Flutter 3.24+

---

## 1. Prerequisites & Environment Setup

Ensure you have the Flutter SDK installed and set up in your path:

```bash
flutter doctor
```

## 2. Workspace Initialization

Run the Melos bootstrap command to resolve all inter-package dependencies across the monorepo:

```bash
npx melos bootstrap
```

## 3. Running Test Suites Across All Packages

To execute unit, integration, and evaluation tests across all workspace packages:

```bash
# Run tests for a specific package:
cd packages/application && dart test

# Run tests workspace-wide:
npx melos run test
```

## 4. Code Formatting & Lint Rules

All packages follow strict Dart linting defined in `analysis_options.yaml`:

```bash
# Format code
dart format .

# Analyze for zero warnings
flutter analyze
```
