#!/usr/bin/env bash
set -euo pipefail

temp=""
if command -v nvidia-smi >/dev/null 2>&1; then
  temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
fi

if [[ -z "$temp" ]]; then
  for hwmon in /sys/class/drm/card*/device/hwmon/hwmon*; do
    if [[ -f "$hwmon/temp1_input" ]]; then
      temp=$(awk '{printf "%.1f", $1/1000}' "$hwmon/temp1_input")
      break
    fi
  done
fi

if [[ -z "$temp" ]] && command -v sensors >/dev/null 2>&1; then
  temp=$(sensors -u 2>/dev/null | awk '/edge|temp1_input/ {print $2; exit}')
fi

if [[ -z "$temp" ]]; then
  echo '{"text":"N/A","tooltip":"GPU temp unavailable"}'
  exit 0
fi

printf '{"text":"%.1fC","tooltip":"GPU temp"}\n' "$temp"
