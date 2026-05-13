#!/usr/bin/env bash
set -euo pipefail

updates=""
if command -v checkupdates >/dev/null 2>&1; then
  updates=$(checkupdates 2>/dev/null || true)
fi

aur_updates=""
if command -v yay >/dev/null 2>&1; then
  aur_updates=$(yay -Qua 2>/dev/null || true)
fi

all_updates=$(printf "%s\n%s\n" "$updates" "$aur_updates" | sed '/^$/d')
count=$(printf "%s\n" "$all_updates" | sed '/^$/d' | wc -l | tr -d ' ')

if [[ "$count" == "0" ]]; then
  echo '{"text":"0","tooltip":"System up to date"}'
  exit 0
fi

printf "%s\n" "$all_updates" > /tmp/waybar-updates-list
printf '{"text":"%s","tooltip":"%s updates"}\n' "$count" "$count"
