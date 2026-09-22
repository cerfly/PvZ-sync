# PvZ 2 Save Sync

Private git backup of the Plants vs. Zombies 2 profile **"User Dave"** (`profile 1771293681`)
so it can be restored to any Android device, even without any account / cloud login.

> **Known gotcha (fixed 2026-09-22):** restoring onto a new device requires the
> **first launch after restore to be OFFLINE** (turn off Wi-Fi / airplane mode).
> Otherwise Google Play Games / cloud automation on the tablet can reset the
> fresh profile to empty (it keeps the player ID but zeroes coins/gems/plants).
> Once the profile has loaded once (even offline), it's established — network can
> come back and it persists.

## Why

PvZ 2's entire profile lives in a handful of files under the app's `No_Backup` folder.
When there's no EA / Google / Apple account, official cloud save isn't available —
but the save files themselves can be copied by hand or with the scripts in `scripts/`.

## Layout

```
saves/com.ea.game.pvz2_na/files/No_Backup/   <- the actual save snapshot
scripts/export-save.sh                       <- adb: phone  -> repo
scripts/import-save.sh                       <- adb: repo   -> phone
backups/                                     <- extra zipped copy
profile-summary.md                           <- decoded profile stats
```

Only the essential files are tracked (`pp.dat`, snapshots, local_profiles,
global_save_data + hash, draper/loot, quest folders). Junk (ad SDK `mb/`,
`cache/`, and the 42 MB `CDN.13.4/` config tree) is excluded — the game re-downloads it.

## Requirements

- `git`
- `adb` (Android platform-tools) — only needed for the scripts
- The game package **must match**: this profile is from `com.ea.game.pvz2_na`
  (North-America build). A device running `com.ea.game.pvz2_row` or a Chinese
  build stores files under a different folder and won't read this save.

## Backup from your phone

1. Close PvZ 2 completely on the phone (or Force-stop).
2. `./scripts/export-save.sh`   (add a serial if `adb devices` shows several)
3. Review changes, then
   `git add saves && git commit -m 'Sync YYYY-MM-DD' && git push`

## Restore to a tablet / new phone

1. Install/update the **PvZ 2 NA** build and launch it once, then **Force-stop** it.
   (Settings > Apps > `com.ea.game.pvz2_na` > Force stop)
2. **Turn the device's network OFF** (airplane mode) — the first launch after a
   restore must be offline, or Google Play Games / cloud automation may reset
   the fresh profile to empty.
3. `./scripts/import-save.sh`  — it auto-backs up the device's save to
   `No_Backup.orig` first, so you can roll back:
   `adb shell 'rm -rf <path>/No_Backup; mv <path>/No_Backup.orig <path>/No_Backup'`
4. Launch the game (still offline). You should see "User Dave" with your
   coins/gems.
5. Close the game, re-enable the network. From now on normal (online) launches
   keep the local save.
6. **Don't link Google Play Games / Apple / EA accounts afterwards**, or an old
   cloud profile can overwrite the freshly restored local save.

> Android 11+ hides `Android/data` from most file managers — that's why the
> scripts use adb (shell can always write there). If you can't use adb, a
> desktop tool such as ZArchiver or a PC + USB (MTP) also works.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Game starts a fresh profile after restore | Wrong package / path. Verify `Android/data/com.ea.game.pvz2_na/files/No_Backup/pp.dat` exists after push. |
| Restored profile loads as empty/fresh (same player ID, 0 coins) | Cloud/Play Games reset it at first boot. Shut network off, restore again, launch once offline, then go online. |
| "Identity selection / conflict" dialog with two GUID identities, both showing 0 coins | Two anonymous identities exist on the device. Wipe and rebuild to a single identity: `adb shell pm clear com.ea.game.pvz2_na`, push the snapshot again (`import-save.sh`), first launch offline. Decline any "connect to Google Play Games" prompt afterwards. |
| Game crashes on load | The save is from a newer game version. Update the game first, then retry. |
| Progress "lost" after linking an account | Unlink / decline cloud sync; restore local save again from this repo. |

## Player ID

If anything goes wrong and you need EA support to recover the profile, quote
player / profile ID **1771293681**.