#!/usr/bin/env bash
# ==============================================================================
# DiLang Complete Developer Environment Setup
# Single entry-point for preparing a fresh machine for development
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "Starting DiLang Environment Setup"

# 1. Bootstrap Dependencies
"${SCRIPT_DIR}/bootstrap.sh"

# 2. Fetch Flutter pub packages
log_info "Fetching Flutter pub dependencies..."
(cd "${MOBILE_APP_DIR}" && flutter pub get)

# 3. Fetch Cargo crates
log_info "Fetching Cargo dependencies..."
(cd "${REPO_ROOT}" && cargo fetch)

# 4. Generate Code
"${SCRIPT_DIR}/generate.sh"

# 5. Build Rust Workspace
log_info "Building Rust Cargo workspace..."
(cd "${REPO_ROOT}" && cargo build)

# 6. Run Static Analysis & Verification
log_info "Running Flutter Analyze..."
(cd "${MOBILE_APP_DIR}" && flutter analyze)

log_info "Running Flutter Unit Tests..."
(cd "${MOBILE_APP_DIR}" && flutter test)

log_info "Running Cargo Workspace Tests..."
(cd "${REPO_ROOT}" && cargo test --workspace)

log_header "Setup Complete! Repository is ready for: ./run linux"
