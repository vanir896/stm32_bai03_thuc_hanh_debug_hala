#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f lesson.elf ]]; then
  echo 'lesson.elf not found. Run: make clean && make'
  exit 1
fi
openocd \
  -f common/openocd/stm32f103_stlink.cfg \
  -c "program lesson.elf verify reset exit"
