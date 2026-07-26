#!/usr/bin/env bash
# ==============================================================================
# DiLang Environment Definitions
# Centralized single source of truth for repository paths & environment variables
# ==============================================================================

if [ -z "${DILANG_ENV_LOADED:-}" ]; then
  DILANG_ENV_LOADED=1

  # Auto-detect Physical Repository Root (Resolving Symlinks)
  export REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

  # Subsystem Directory Paths
  export CRATES_DIR="${REPO_ROOT}/crates"
  export CORE_CRATE_DIR="${CRATES_DIR}/core"
  export FFI_CRATE_DIR="${CRATES_DIR}/ffi"
  export APPS_DIR="${REPO_ROOT}/apps"
  export MOBILE_APP_DIR="${APPS_DIR}/mobile"
  export ASSETS_DIR="${REPO_ROOT}/assets"
  export MODELS_DIR="${REPO_ROOT}/models"
  export DOCS_DIR="${REPO_ROOT}/docs"
  export SCRIPTS_DIR="${REPO_ROOT}/scripts"

  # Generated Artifacts Directories
  export RUST_TARGET_DIR="${REPO_ROOT}/target"
  export FLUTTER_BUILD_DIR="${MOBILE_APP_DIR}/build"
  export FRB_GEN_RUST="${FFI_CRATE_DIR}/src/frb_generated.rs"
  export FRB_GEN_DART="${MOBILE_APP_DIR}/lib/src/frb_generated.dart"

  # Tools Pointers
  export CARGO_BIN="${CARGO_BIN:-cargo}"
  export FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
  export DART_BIN="${DART_BIN:-dart}"
fi
