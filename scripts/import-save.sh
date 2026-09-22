#!/usr/bin/env bash
#
# import-save.sh — restore the save snapshot from this repo onto an Android device
#
#   Usage:  ./import-save.sh [serial]
#
#   Requires adb. Steps performed:
#     1. Checks the device / package path.
#     2. Backs up the device's current No_Backup to No_Backup.orig
#     3. Pushes the repo's snapshot over it.
#
#   IMPORTANT:
#     - Close the game completely on the device FIRST
#       (Settings > Apps > com.ea.game.pvz2_na > Force stop).
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

echo "==> Pushing repo snapshot (${SRC})"
"${ADB[@]}" push "$SRC/." "$DEST/"

echo "==> Done. Launch PvZ 2; you should see the restored profile."
echo "    Rollback: adb shell 'rm -rf '$DEST'; mv '$DEST.orig' '$DEST''"