#!/usr/bin/env bash
set -euo pipefail

device=$(upower -e 2>/dev/null | grep -i xbox | head -n1 || true)
if [[ -z "$device" ]]; then
  echo '{"text":"N/A","tooltip":"Xbox battery not found"}'
  exit 0
fi

percent=$(upower -i "$device" | awk '/percentage/ {print $2; exit}')
state=$(upower -i "$device" | awk '/state/ {print $2; exit}')

if [[ -z "$percent" ]]; then
  echo '{"text":"N/A","tooltip":"Xbox battery unavailable"}'
  exit 0
fi

printf '{"text":"%s","tooltip":"Xbox %s"}\n' "$percent" "${state:-unknown}"
