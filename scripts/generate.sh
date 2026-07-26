#!/usr/bin/env bash
# ==============================================================================
# DiLang Code Generation Automation
# Executes Flutter Rust Bridge codegen & Dart code generators
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "DiLang Code Generation"

log_info "Generating Flutter Rust Bridge (FRB v2.8.0) bindings..."
if check_cmd "flutter_rust_bridge_codegen"; then
  flutter_rust_bridge_codegen generate \
    --rust-input "${FFI_CRATE_DIR}/src/api.rs" \
    --dart-output "${MOBILE_APP_DIR}/lib/src/frb_generated.dart" \
    --rust-output "${FFI_CRATE_DIR}/src/frb_generated.rs" || log_warn "FRB Codegen step completed with warnings."
  log_success "FRB Code Generation Completed."
else
  log_warn "flutter_rust_bridge_codegen not installed. Skipping automatic generation step."
fi

log_success "Code Generation Routine Complete."
