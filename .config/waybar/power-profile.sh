#!/usr/bin/env bash

set -euo pipefail

BUS_DEST="net.hadess.PowerProfiles"
BUS_PATH="/net/hadess/PowerProfiles"
BUS_IFACE="net.hadess.PowerProfiles"
PROP_IFACE="org.freedesktop.DBus.Properties"

get_profile() {
  gdbus call \
    --system \
    --dest "$BUS_DEST" \
    --object-path "$BUS_PATH" \
    --method "$PROP_IFACE.Get" \
    "$BUS_IFACE" \
    ActiveProfile | sed -E "s/.*<'([^']+)'.*/\1/"
}

set_profile() {
  local profile="$1"
  gdbus call \
    --system \
    --dest "$BUS_DEST" \
    --object-path "$BUS_PATH" \
    --method "$PROP_IFACE.Set" \
    "$BUS_IFACE" \
    ActiveProfile \
    "<'$profile'>" >/dev/null
}

print_status() {
  local profile icon
  profile="$(get_profile)"

  case "$profile" in
    power-saver)
      icon=""
      ;;
    balanced)
      icon=""
      ;;
    performance)
      icon=""
      ;;
    *)
      icon=""
      ;;
  esac

  printf '{"text":"%s","tooltip":"Power profile: %s","class":"%s"}\n' \
    "$icon" "$profile" "$profile"
}

cycle_profile() {
  local current next
  current="$(get_profile)"

  case "$current" in
    power-saver)
      next="balanced"
      ;;
    balanced)
      next="performance"
      ;;
    performance)
      next="power-saver"
      ;;
    *)
      next="balanced"
      ;;
  esac

  set_profile "$next"
}

case "${1:-status}" in
  --cycle)
    cycle_profile
    ;;
  status|--status)
    print_status
    ;;
  *)
    print_status
    ;;
esac
