#!/usr/bin/env bash
# ==============================================================================
# DiLang Doctor Diagnostic Tool
# Validates developer environment health, tool versions, and directory status
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_header "DiLang System Environment Doctor"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

check_item() {
  local name="$1"
  local cmd="$2"
  if eval "${cmd}" >/dev/null 2>&1; then
    echo -e "  [ ${GREEN}PASS${RESET} ] ${name}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "  [ ${RED}FAIL${RESET} ] ${name}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

check_item_warn() {
  local name="$1"
  local cmd="$2"
  if eval "${cmd}" >/dev/null 2>&1; then
    echo -e "  [ ${GREEN}PASS${RESET} ] ${name}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "  [ ${YELLOW}WARN${RESET} ] ${name}"
    WARN_COUNT=$((WARN_COUNT + 1))
  fi
}

log_info "Running System Checks:"
check_item "Rust Toolchain (rustc)" "rustc --version"
check_item "Cargo Package Manager" "cargo --version"
check_item "Flutter SDK" "flutter --version"
check_item "Dart SDK" "dart --version"
check_item_warn "Android SDK Setup" "flutter doctor"
check_item "Linux Build Tool (CMake)" "cmake --version"
check_item "Git Version Control" "git --version"
check_item_warn "Flutter Rust Bridge Codegen" "flutter_rust_bridge_codegen --version"

log_info "Verifying Workspace Directories:"
check_item "Crates Directory" "test -d ${CRATES_DIR}"
check_item "Mobile App Directory" "test -d ${MOBILE_APP_DIR}"
check_item "Assets Directory" "test -d ${ASSETS_DIR}"

log_header "Doctor Summary: ${PASS_COUNT} PASSED, ${WARN_COUNT} WARNINGS, ${FAIL_COUNT} ERRORS"

if [ "${FAIL_COUNT}" -gt 0 ]; then
  log_error "Environment verification failed. Please fix reported ERRORS."
  exit 1
else
  log_success "Environment is Healthy and Ready!"
fi
