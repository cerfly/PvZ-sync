#!/usr/bin/env bash
#
# import-save.sh — restore the save snapshot from this repo onto an Android device
#
#   Usage:  ./import-save.sh [serial]
#
#   Requires adb. Steps performed:
#     1. Checks the device / package path.
#     2. Backs up the device's current No_Backup to No_Backup.orig
#     3. Replaces the destination contents (so stale files cannot survive)
#     4. Pushes the repo's snapshot into the clean directory.
#
#   IMPORTANT:
#     - Close the game completely on the device FIRST
#       (Settings > Apps > com.ea.game.pvz2_na > Force stop).
#     - CRITICAL: keep the device GENUINELY OFFLINE for the first launch after
#       restore. Disable Wi-Fi and mobile data, stop the VPN, and verify that
#       no active network remains; airplane-mode setting alone is insufficient.
#       Google Play Games / cloud automation resets a fresh profile to empty if
#       the network is on at first boot. Keep the moved device offline afterward.
#     - The device must run the same region package: com.ea.game.pvz2_na
#       (advanced/global package com.ea.game.pvz2_row uses a different folder).
#     - After first launch, do NOT sign into Google Play Games / Game Center
#       with an old cloud profile — it can overwrite the local save.
#
set -euo pipefail

PKG="com.ea.game.pvz2_na"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/saves/$PKG/files/No_Backup"
DEST="/sdcard/Android/data/$PKG/files/No_Backup"

ADB=(adb)
if [[ -n "${1:-}" ]]; then
  ADB+=( -s "$1" )
fi

"${ADB[@]}" get-state >/dev/null 2>&1 || { echo "No device reachable."; exit 1; }

if [[ ! -d "$SRC" ]]; then
  echo "No save snapshot found here: $SRC"
  echo "Run ./export-save.sh first, or check the files are committed."
  exit 1
fi

# Sanity check that the snapshot actually contains a profile
if [[ ! -f "$SRC/pp.dat" ]]; then
  echo "$SRC/pp.dat missing — aborting."; exit 1
fi

if ! "${ADB[@]}" shell "test -d '$DEST' && echo ok" | grep -q ok; then
  echo "Save path not found on device: $DEST"
  echo "Launch PvZ 2 once (let it create the folder), Force-stop it, then rerun."
  exit 1
fi

echo "==> Backing up current device save to No_Backup.orig"
"${ADB[@]}" shell "rm -rf '$DEST.orig' && cp -r '$DEST' '$DEST.orig'"

echo "==> Clearing destination contents (prevents stale files surviving the push)"
"${ADB[@]}" shell "rm -rf '$DEST' && mkdir -p '$DEST'"

echo "==> Pushing repo snapshot (${SRC})"
if ! "${ADB[@]}" push "$SRC/." "$DEST/"; then
  echo "Push failed; attempting to roll back to No_Backup.orig" >&2
  "${ADB[@]}" shell "rm -rf '$DEST' && mv '$DEST.orig' '$DEST'" || true
  exit 1
fi

echo "==> Done. Launch PvZ 2; you should see the restored profile."
echo "    Keep the device genuinely offline before and after this first launch."
echo "    Verify the name, progression, and pp.dat before doing anything else."
echo "    Rollback: adb shell 'rm -rf '$DEST'; mv '$DEST.orig' '$DEST''"
