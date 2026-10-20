#!/bin/bash
set -euo pipefail

log() { echo -e "\033[1;32m[+] $*\033[0m"; }
err() { echo -e "\033[1;31m[!] $*\033[0m"; exit 1; }

verify_kernel_version() {
  local expected="$1"
  local actual
  actual=$(make kernelversion 2>/dev/null || echo "unknown")
  log "Kernel version: $actual (expected ~$expected)"
}
