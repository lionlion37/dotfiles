#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="/home/liondungl/.config/waybar/power-menu.sh"

swaynag_cmd() {
  swaynag \
    --edge bottom \
    --layer overlay \
    --background 18181bee \
    --border f4f4f5ff \
    --border-bottom f4f4f5ff \
    --button-background 27272aff \
    --text f4f4f5ff \
    --button-text f4f4f5ff \
    --border-bottom-size 2 \
    --message-padding 10 \
    --button-border-size 0 \
    --button-gap 8 \
    --button-dismiss-gap 8 \
    --button-margin-right 10 \
    --button-padding 6 \
    "$@"
}

lock_screen() {
  if command -v swaylock >/dev/null 2>&1; then
    swaylock
    return
  fi

  swaynag_cmd -t warning -m "No lock command found." -s "Close"
}

logout_session() {
  swaymsg exit
}

run_action() {
  local action="$1"

  case "$action" in
    lock)
      lock_screen
      ;;
    logout)
      logout_session
      ;;
    suspend)
      lock_screen || true
      systemctl suspend
      ;;
    reboot)
      systemctl reboot
      ;;
    shutdown)
      systemctl poweroff
      ;;
    *)
      exit 1
      ;;
  esac
}

show_confirm() {
  local action="$1"
  local label="$2"

  swaynag_cmd \
    -t warning \
    -m "$label?" \
    -s "Cancel" \
    -Z "Yes" "$SCRIPT_PATH --run $action"
}

show_menu() {
  swaynag_cmd \
    -m "Power" \
    -s "Close" \
    -Z "Lock" "$SCRIPT_PATH --run lock" \
    -Z "Logout" "$SCRIPT_PATH --confirm logout" \
    -Z "Suspend" "$SCRIPT_PATH --confirm suspend" \
    -Z "Reboot" "$SCRIPT_PATH --confirm reboot" \
    -Z "Shutdown" "$SCRIPT_PATH --confirm shutdown"
}

case "${1:-menu}" in
  --run)
    run_action "${2:-}"
    ;;
  --confirm)
    case "${2:-}" in
      logout)
        show_confirm logout "Logout"
        ;;
      suspend)
        show_confirm suspend "Suspend"
        ;;
      reboot)
        show_confirm reboot "Reboot"
        ;;
      shutdown)
        show_confirm shutdown "Shutdown"
        ;;
      *)
        exit 1
        ;;
    esac
    ;;
  menu|--menu)
    show_menu
    ;;
  *)
    exit 0
    ;;
esac
