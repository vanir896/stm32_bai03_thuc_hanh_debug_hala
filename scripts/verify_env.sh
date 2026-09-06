#!/usr/bin/env bash
set -euo pipefail

check_cmd() {
  local cmd="$1"
  local label="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'FAIL: %-14s not found in PATH\n' "$label"
    exit 1
  fi
}

check_cmd arm-none-eabi-gcc "ARM GCC"
check_cmd arm-none-eabi-gdb "ARM GDB"
check_cmd openocd "OpenOCD"
check_cmd make "Make"

printf 'HALA STM32F103 Debug Environment Check\n'
printf '%-18s' 'ARM GCC:'; arm-none-eabi-gcc --version | head -1
printf '%-18s' 'ARM GDB:'; arm-none-eabi-gdb --version | head -1
printf '%-18s' 'OpenOCD:'; openocd --version 2>&1 | head -1
printf '%-18s' 'Make:'; make --version | head -1
printf 'Project:           L03_STUDENT_PROJECT\n'
printf 'Target:            STM32F103C8 / Cortex-M3\n'
printf 'Debug transport:   SWD\n'
printf 'ENV PASS\n'
