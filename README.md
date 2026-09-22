# PvZ 2 Save Sync

Private git backup of the Plants vs. Zombies 2 profile **"User Dave"** (`profile 1771293681`)
so it can be restored to any Android device, even without any account / cloud login.

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
2. `./scripts/import-save.sh`  — it auto-backs up the device's save to
   `No_Backup.orig` first, so you can roll back:
   `adb shell 'rm -rf <path>/No_Backup; mv <path>/No_Backup.orig <path>/No_Backup'`
3. Launch the game. You should see "User Dave" with your coins/gems.
4. **Don't link Google Play Games / Apple / EA accounts afterwards**, or an old
   cloud profile can overwrite the freshly restored local save.

> Android 11+ hides `Android/data` from most file managers — that's why the
> scripts use adb (shell can always write there). If you can't use adb, a
> desktop tool such as ZArchiver or a PC + USB (MTP) also works.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Game starts a fresh profile after restore | Wrong package / path. Verify `Android/data/com.ea.game.pvz2_na/files/No_Backup/pp.dat` exists after push. |
| Game crashes on load | The save is from a newer game version. Update the game first, then retry. |
| Progress "lost" after linking an account | Unlink / decline cloud sync; restore local save again from this repo. |

## Player ID

If anything goes wrong and you need EA support to recover the profile, quote
player / profile ID **1771293681**.