# DiLang Developer Automation Scripts Toolkit

Professional cross-platform build, test, generation, and environment automation system for the DiLang monorepo.

---

## Script System Index

| Script | Purpose | Typical Usage |
| :--- | :--- | :--- |
| `bootstrap.sh` | Verify and install required toolchain dependencies | `./scripts/bootstrap.sh` |
| `doctor.sh` | Environment diagnostic health check (`PASS` / `WARN` / `FAIL`) | `./scripts/doctor.sh` |
| `setup.sh` | Complete first-time developer environment setup | `./scripts/setup.sh` or `./setup` |
| `generate.sh` | Flutter Rust Bridge (FRB v2.8.0) code generation | `./scripts/generate.sh` |
| `build.sh` | Package cross-platform binaries (`linux`, `android`, `apk`, `windows`, `macos`, `ios`) | `./scripts/build.sh linux` |
| `run.sh` | Launch application on target platform | `./scripts/run.sh linux` or `./run linux` |
| `test.sh` | Execute complete Cargo & Flutter test suites | `./scripts/test.sh` or `./test` |
| `lint.sh` | Run Rust clippy and Flutter analyze static checks | `./scripts/lint.sh` |
| `clean.sh` | Clean build targets (`normal`, `deep`, `cache`) | `./scripts/clean.sh deep` or `./clean deep` |
| `models.sh` | AI model weight management (`list`, `verify`, `download`, `clean`) | `./scripts/models.sh list` |
| `release.sh` | Automated release packaging pipeline | `./scripts/release.sh linux` |

---

## Developer Workflow Guide

### 1. First-Time Setup
Clone the repository and run:
```bash
git clone git@github.com:Sugarcube08/DiLang.git
cd DiLang-v2
./setup
```

### 2. Launch App
```bash
./run linux
```

### 3. Run Test Suite
```bash
./test
```

### 4. Deep Clean
```bash
./clean deep
```
