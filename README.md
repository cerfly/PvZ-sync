# PvZ 2 Save Sync

Private git backup of the Plants vs. Zombies 2 profile **"User Dave"** (`profile 1771293681`)
so it can be restored to any Android device, even without any account / cloud login.

> **Known gotcha (revalidated 2026-09-25):** restoring onto a new device requires the
> **first launch after restore to be genuinely OFFLINE**. On this Pad,
> `airplane_mode_on=1` was reported while Wi-Fi and the Clash VPN were still active.
> A true offline check requires disabling Wi-Fi and mobile data, stopping the VPN,
> and confirming `wlan0` is down and no `tun0`/active network exists. The full
> **User Dave** profile then loaded and remained stable for at least 90 seconds.
> A later direct-Wi-Fi launch (without Clash) collapsed the profile within 8
> seconds; logcat showed Google Play Games `SignInPerformer` / `CloudSilentSync`
> activity. No manual account linking was performed, but the Pad's Play Games
> stack was already handling an installer-selected account. Do not reconnect the
> moved-to device to the network or link an old cloud profile unless you are
> prepared to restore the save again.

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
2. **Turn the device's network genuinely OFF** — disable Wi-Fi and mobile data,
   stop the VPN, and verify there is no active network. Airplane-mode setting
   alone was not sufficient on the tested Pad. The first launch after a restore
   must be offline, or Google Play Games / cloud automation may reset the
   fresh profile to empty.
3. `./scripts/import-save.sh`  — it auto-backs up the device's save to
   `No_Backup.orig` first, so you can roll back:
   `adb shell 'rm -rf <path>/No_Backup; mv <path>/No_Backup.orig <path>/No_Backup'`
4. Launch the game (still offline). You should see "User Dave" with your
   coins/gems. Keep the device offline while using the moved profile.
5. Do not reconnect the moved-to device to the network. The original device may
   continue playing online, but a different install has a separate cloud/player
   identity and can overwrite the restored local save.
6. **Don't link Google Play Games / Apple / EA accounts on the moved device**;
   an old cloud profile can overwrite the freshly restored local save.

> Android 11+ hides `Android/data` from most file managers — that's why the
> scripts use adb (shell can always write there). If you can't use adb, a
> desktop tool such as ZArchiver or a PC + USB (MTP) also works.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Game starts a fresh profile after restore | Wrong package / path. Verify `Android/data/com.ea.game.pvz2_na/files/No_Backup/pp.dat` exists after push. |
| Restored profile loads as empty/fresh (same player ID, 0 coins) | A network path was still active. Hard-disable Wi-Fi/mobile data and the VPN, restore again, and keep the moved device offline. Do not go online on the moved device. |
| "Identity selection / conflict" dialog with two GUID identities, both showing 0 coins | Two anonymous identities exist on the device. Wipe and rebuild to a single identity: `adb shell pm clear com.ea.game.pvz2_na`, push the snapshot again (`import-save.sh`), first launch offline. Decline any "connect to Google Play Games" prompt afterwards. |
| Profile resets to 0 coins/gems on an online boot on a *different* device | **Fundamental per-install identity limitation, not fixable by files.** In the guarded test, direct Wi-Fi (no VPN) caused the file to collapse within 8 seconds; logcat showed Google Play Games `SignInPerformer` / `CloudSilentSync`. The source phone's online identity is not the same as the Pad's anonymous install. First boot genuinely offline holds (verified ≥90s); keep the moved device offline. Play online on the original device, or pursue EA account linking. |
| Game crashes on load | The save is from a newer game version. Update the game first, then retry. |
| Progress "lost" after linking an account | Unlink / decline cloud sync; restore local save again from this repo. |

## Player ID

If anything goes wrong and you need EA support to recover the profile, quote
player / profile ID **1771293681**.