#!/usr/bin/env bash
set -euo pipefail

if command -v yay >/dev/null 2>&1; then
  yay -Syu
else
  sudo pacman -Syu
fi
