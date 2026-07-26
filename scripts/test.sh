#!/usr/bin/env bash
# ==============================================================================
# DiLang Test Automation Runner
# Runs cargo test, cargo clippy, flutter analyze, and flutter test
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "Executing Complete Test Suite"

log_info "1. Running Cargo Format Check..."
(cd "${REPO_ROOT}" && cargo fmt --check) || log_warn "Cargo fmt found formatting suggestions."

log_info "2. Running Cargo Clippy..."
(cd "${REPO_ROOT}" && cargo clippy -- -D warnings)

log_info "3. Running Cargo Workspace Tests..."
(cd "${REPO_ROOT}" && cargo test --workspace)

log_info "4. Running Flutter Analyze..."
(cd "${MOBILE_APP_DIR}" && flutter analyze)

log_info "5. Running Flutter Unit Tests..."
(cd "${MOBILE_APP_DIR}" && flutter test)

log_success "All Test Suites Passed Cleanly!"
