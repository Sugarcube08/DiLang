#!/usr/bin/env bash
# ==============================================================================
# DiLang Bootstrap System
# Prepares toolchain requirements & installs missing Rust components
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "DiLang Monorepo Bootstrap"

log_info "Verifying core development dependencies..."

# Verification list
REQUIRED_TOOLS=("rustc" "cargo" "flutter" "dart" "git" "cmake")

for tool in "${REQUIRED_TOOLS[@]}"; do
  if check_cmd "${tool}"; then
    log_success "Found ${tool}: $(command -v "${tool}")"
  else
    log_warn "Missing required tool: ${tool}"
  fi
done

# Install flutter_rust_bridge_codegen if missing
if ! check_cmd "flutter_rust_bridge_codegen"; then
  log_info "Installing flutter_rust_bridge_codegen (v2.8.0)..."
  cargo install flutter_rust_bridge_codegen --version 2.8.0 || log_warn "Failed to cargo install flutter_rust_bridge_codegen automatically."
else
  log_success "flutter_rust_bridge_codegen is available."
fi

log_success "Bootstrap Complete"
