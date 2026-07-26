#!/usr/bin/env bash
# ==============================================================================
# DiLang Script Utilities & Logging Helpers
# Reusable terminal styling, error reporting, and helper functions
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

# Color Codes
if [ -t 1 ]; then
  BOLD='\033[1m'
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  MAGENTA='\033[0;35m'
  CYAN='\033[0;36m'
  RESET='\033[0m'
else
  BOLD=''
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  MAGENTA=''
  CYAN=''
  RESET=''
fi

log_info() {
  echo -e "${BLUE}[INFO]${RESET} $*"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

log_warn() {
  echo -e "${YELLOW}[WARNING]${RESET} $*"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $*" >&2
}

log_header() {
  echo -e "\n${BOLD}${MAGENTA}========================================================================${RESET}"
  echo -e "${BOLD}${MAGENTA} $*${RESET}"
  echo -e "${BOLD}${MAGENTA}========================================================================${RESET}\n"
}

error_handler() {
  local exit_code=$?
  local line_number=$1
  log_error "Script failed at line ${line_number} with exit code ${exit_code}."
  exit "${exit_code}"
}

trap 'error_handler ${LINENO}' ERR

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}
