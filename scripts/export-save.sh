#!/usr/bin/env bash
#
# export-save.sh — pull the PvZ 2 save from an Android device into this repo
#
#   Usage:  ./export-save.sh [serial]
#
#   - serial is optional (`adb devices` to list). Defaults to the only device.
#   - Requires: adb (Android platform-tools) and a USB cable / wifi-adb.
#   - The game must be fully CLOSED on the phone before exporting
#     (swipe it away, or Settings > Apps > PvZ 2 > Force stop).
#
set -euo pipefail

PKG="com.ea.game.pvz2_na"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$REPO_DIR/saves/$PKG/files/No_Backup"
SRC="/sdcard/Android/data/$PKG/files/No_Backup"

ADB=(adb)
if [[ -n "${1:-}" ]]; then
  ADB+=( -s "$1" )
fi

"${ADB[@]}" get-state >/dev/null 2>&1 || { echo "No device reachable. Connect a device (USB debugging on) and try again."; exit 1; }

echo "Source device package: $PKG"
if ! "${ADB[@]}" shell "test -d '$SRC' && echo ok" | grep -q ok; then
  echo "Save path not found on device: $SRC"
  echo "Have you launched PvZ 2 at least once? Is the region package correct?"
  exit 1
fi

mkdir -p "$DEST"

echo "---- Pulling core files ----"
for f in pp.dat snapshot1.dat snapshot2.dat local_profiles global_save_data global_save_data.hash; do
  if "${ADB[@]}" pull "$SRC/$f" "$DEST/" 2>/dev/null | grep -q '1 file'; then
    echo "  ok: $f"
  else
    echo "  skip: $f (not present?)"
  fi
done

echo "---- Pulling profile-specific files ----"
# draper_<id> (arena history), loot<id> (loot tables), plus quest folders
while IFS= read -r name; do
  name="${name%$'\r'}"                       # strip CR from adb shell output
  case "$name" in
    draper_*|loot*) "${ADB[@]}" pull "$SRC/$name" "$DEST/" 2>/dev/null | grep -q '1 file' && echo "  ok: $name" ;;
    activequests|dailyquests)
      "${ADB[@]}" pull "$SRC/$name" "$DEST/" >/dev/null 2>&1 && echo "  ok: dir $name/" ;;
  esac
done < <("${ADB[@]}" shell "ls -1 '$SRC'" 2>/dev/null)

echo "---- Done. Verify, then commit: ----"
echo "  git add saves && git commit -m 'Sync save YYYY-MM-DD' && git push"