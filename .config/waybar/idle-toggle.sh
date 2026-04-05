#!/usr/bin/env bash

set -euo pipefail

LOCK_TIMEOUT="${LOCK_TIMEOUT:-600}"
SCREEN_TIMEOUT="${SCREEN_TIMEOUT:-60}"

is_enabled() {
  pgrep -xu "$USER" swayidle >/dev/null 2>&1
}

start_idle() {
  if is_enabled; then
    return
  fi

  nohup swayidle -w \
    timeout "$LOCK_TIMEOUT" 'swaylock -f' \
    timeout "$((LOCK_TIMEOUT + SCREEN_TIMEOUT))" 'swaymsg "output * power off"' \
                  resume 'swaymsg "output * power on"' \
    timeout "$SCREEN_TIMEOUT" 'pgrep -xu "$USER" swaylock >/dev/null && swaymsg "output * power off"' \
         resume 'pgrep -xu "$USER" swaylock >/dev/null && swaymsg "output * power on"' \
    before-sleep 'swaylock -f' \
    lock 'swaylock -f' \
    unlock 'pkill -xu "$USER" -SIGUSR1 swaylock' \
    >/dev/null 2>&1 &
}

stop_idle() {
  pkill -xu "$USER" swayidle || true
}

print_status() {
  if is_enabled; then
    printf '{"text":"󰛊","tooltip":"Auto-suspend active after %d min","class":"enabled"}\n' "$((LOCK_TIMEOUT / 60))"
  else
    printf '{"text":"󰪥","tooltip":"Auto-suspend disabled","class":"disabled"}\n'
  fi
}

case "${1:-status}" in
  --toggle)
    if is_enabled; then
      stop_idle
    else
      start_idle
    fi
    ;;
  status|--status)
    print_status
    ;;
  *)
    print_status
    ;;
esac
