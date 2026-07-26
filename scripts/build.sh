#!/usr/bin/env bash
# ==============================================================================
# DiLang Cross-Platform Application Builder
# Builds Rust core and packages Flutter for target platforms
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

TARGET="${1:-linux}"

log_header "Building DiLang for Target: ${TARGET}"

# Generate bindings first
"${SCRIPT_DIR}/generate.sh"

case "${TARGET}" in
  linux)
    log_info "Building Linux Desktop bundle..."
    (cd "${MOBILE_APP_DIR}" && flutter build linux)
    ;;
  apk)
    log_info "Building Android APK..."
    (cd "${MOBILE_APP_DIR}" && flutter build apk)
    ;;
  android)
    log_info "Building Android App Bundle..."
    (cd "${MOBILE_APP_DIR}" && flutter build appbundle)
    ;;
  windows)
    log_info "Building Windows Desktop executable..."
    (cd "${MOBILE_APP_DIR}" && flutter build windows)
    ;;
  macos)
    log_info "Building macOS Desktop bundle..."
    (cd "${MOBILE_APP_DIR}" && flutter build macos)
    ;;
  ios)
    log_info "Building iOS bundle..."
    (cd "${MOBILE_APP_DIR}" && flutter build ios --no-codesign)
    ;;
  *)
    log_error "Unknown build target: ${TARGET}. Supported: linux, android, apk, windows, macos, ios"
    exit 1
    ;;
esac

log_success "Build completed successfully for ${TARGET}!"
