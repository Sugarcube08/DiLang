#!/usr/bin/env bash
# ==============================================================================
# DiLang Static Analysis & Linting Pipeline
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "Running Static Linter Checks"

log_info "Linting Rust Workspace..."
(cd "${REPO_ROOT}" && cargo clippy)

log_info "Linting Flutter Mobile App..."
(cd "${MOBILE_APP_DIR}" && flutter analyze)

log_success "Linting Checks Complete!"
