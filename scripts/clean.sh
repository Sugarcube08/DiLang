#!/usr/bin/env bash
# ==============================================================================
# DiLang Workspace Cleanup Manager
# Cleans build artifacts, generated code, and Cargo caches
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

MODE="${1:-normal}"

log_header "Cleaning Workspace Artifacts: Mode [${MODE}]"

case "${MODE}" in
  normal)
    log_info "Cleaning Flutter build and Cargo target..."
    (cd "${MOBILE_APP_DIR}" && flutter clean)
    (cd "${REPO_ROOT}" && cargo clean)
    ;;
  deep)
    log_info "Deep cleaning generated FRB files, target directories, and build artifacts..."
    (cd "${MOBILE_APP_DIR}" && flutter clean)
    (cd "${REPO_ROOT}" && cargo clean)
    rm -rf "${FLUTTER_BUILD_DIR}" "${RUST_TARGET_DIR}"
    ;;
  cache)
    log_info "Cleaning pub and cargo caches..."
    (cd "${MOBILE_APP_DIR}" && flutter pub cache clean --force)
    ;;
  *)
    log_error "Unknown clean mode: ${MODE}. Supported: normal, deep, cache"
    exit 1
    ;;
esac

log_success "Clean completed successfully!"
