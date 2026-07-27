#!/usr/bin/env bash
# ==============================================================================
# DiLang Application Runner
# Verifies setup, generates code, and launches Flutter on target platform
# ==============================================================================

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

PLATFORM="linux"
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--device)
      if [[ -n "${2:-}" && ! "$2" =~ ^- ]]; then
        PLATFORM="$2"
        shift 2
      else
        shift 1
      fi
      ;;
    *)
      if [[ "$1" != -* ]]; then
        PLATFORM="$1"
      else
        EXTRA_ARGS+=("$1")
      fi
      shift 1
      ;;
  esac
done

log_header "Launching DiLang on Platform/Device: ${PLATFORM}"

"${SCRIPT_DIR}/generate.sh"

log_info "Executing Flutter Run for -d ${PLATFORM}..."
(cd "${MOBILE_APP_DIR}" && flutter run -d "${PLATFORM}" "${EXTRA_ARGS[@]}")
