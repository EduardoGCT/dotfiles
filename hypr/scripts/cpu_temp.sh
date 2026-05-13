#!/usr/bin/env bash
set -euo pipefail

temp=""
if command -v sensors >/dev/null 2>&1; then
  temp=$(sensors -u 2>/dev/null | awk '/temp1_input/ {print $2; exit}')
fi

if [[ -z "$temp" ]] && [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
  temp=$(awk '{printf "%.1f", $1/1000}' /sys/class/thermal/thermal_zone0/temp)
fi

if [[ -z "$temp" ]]; then
  echo '{"text":"N/A","tooltip":"CPU temp unavailable"}'
  exit 0
fi

printf '{"text":"%.1fC","tooltip":"CPU temp"}\n' "$temp"
