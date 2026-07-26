#!/usr/bin/env bash
# ==============================================================================
# DiLang Application Runner
# Verifies setup, generates code, and launches Flutter on target platform
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

PLATFORM="${1:-linux}"

log_header "Launching DiLang on Platform: ${PLATFORM}"

"${SCRIPT_DIR}/generate.sh"

log_info "Executing Flutter Run for -d ${PLATFORM}..."
(cd "${MOBILE_APP_DIR}" && flutter run -d "${PLATFORM}")
