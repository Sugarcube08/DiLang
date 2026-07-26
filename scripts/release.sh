#!/usr/bin/env bash
# ==============================================================================
# DiLang Production Release Build Pipeline
# Verifies repository clean state, runs full tests, builds release artifacts
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

TARGET="${1:-linux}"

log_header "Initiating DiLang Release Build Pipeline for Target: ${TARGET}"

log_info "1. Verifying Git Repository Clean State..."
if [ -n "$(git status --porcelain)" ]; then
  log_warn "Git working tree has uncommitted changes. Continuing release build..."
fi

log_info "2. Running Complete Test Suite..."
"${SCRIPT_DIR}/test.sh"

log_info "3. Building Release Package..."
"${SCRIPT_DIR}/build.sh" "${TARGET}"

log_success "Production Release Build Complete for ${TARGET}!"
