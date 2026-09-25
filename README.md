# PvZ 2 Save Sync

Private, evidence-preserving backup of the local Plants vs. Zombies 2 NA profile
**“User Dave”** (local profile ID `1771293681`). It can be restored to another
Android install for **offline** use, subject to using the matching NA package.
The repository does not contain or transfer a Google/EA account, a Google Play
Games player association, or a remote cloud snapshot.

> **Critical finding (revalidated 2026-09-25):** a restored profile must be
> launched with the device genuinely offline. On the tested Pad,
> `airplane_mode_on=1` was reported while Wi-Fi and a VPN were still active.
> Disable Wi-Fi and mobile data, stop the VPN, and confirm that `wlan0` is down
> and no active network remains. The full **User Dave** profile then loaded and
> remained stable for at least 90 seconds.
>
> A later direct-Wi-Fi startup, without the VPN, caused the profile to collapse
> within about eight seconds. Logcat showed automatic Google Play Games
> `SignInPerformer` / `CloudSilentSync` activity; no manual account linking was
> performed. The Pad had already selected an installer-associated account. Do
> not reconnect the moved-to device or link an old cloud profile unless a
> same-credential procedure and one-device-at-a-time plan are in place.

## EA's current guidance

EA replied that PvZ2 progress cannot be transferred between mobile devices. To
access the data on a secondary device, use the **same credentials**; the account
is intended to be active on only one device at a time. This is not a promise
that the local file copy is an official transfer method, and it does not yet
identify whether this profile uses a Google Play Games account, an EA account,
or both.

Keep the source phone inactive/offline before any approved secondary-device
sign-in. Do not use both devices online with the same account.

## Why this is separate from cloud identity

The tested NA APK (13.4.1, build 1055) starts a Google Play Games snapshot sync
path after sign-in. Static analysis shows that the app opens the fixed snapshot
name **`PvZ2-1.pvz2`**, reads a successful result into the game, and commits
snapshots when saving. That is the strongest supported explanation for the
online collapse, but the exact remote payload and owning Google account were
not recovered. The snapshot name is not keyed by `1771293681`.

The local files and cloud state are therefore separate layers. A file restore
can make the profile appear correctly while leaving the device attached to a
different cloud/player association. The GUID found in quest data is unverified
and is not documented here as an EA GIN.

See [`docs/transfer-procedure.md`](docs/transfer-procedure.md) for the full
evidence and confidence limits.

## Layout

```text
saves/com.ea.game.pvz2_na/files/No_Backup/   verified local save snapshot
scripts/export-save.sh                      adb: phone  -> repo
scripts/import-save.sh                      adb: repo   -> phone
backups/                                    recovery archive
profile-summary.md                          decoded local profile details
docs/transfer-procedure.md                  diagnosis and controlled procedure
docs/ea-support-email-template.md           qualified support request
```

Only essential local files are tracked (`pp.dat`, snapshots, `local_profiles`,
`global_save_data` and its hash, draper/loot data, and quest folders). Junk such
as ad-SDK `mb/`, `cache/`, and the large `CDN.13.4/` resource tree is excluded;
the game can re-download resources when a supported network is available.

## Requirements

- `git`
- `adb` (Android platform-tools) for the scripts
- The game package must match: `com.ea.game.pvz2_na` (North America). The
  `com.ea.game.pvz2_row`/other regional package may use a different path and is
  not interchangeable with this snapshot.

## Backup from the source device

1. Close PvZ 2 completely on the source phone (or use **Force stop**).
2. Run `./scripts/export-save.sh` (add a serial if `adb devices` lists several).
3. Review the changes, then commit and push the save.

This exports local game files only. It does not export the Google Play Games
snapshot or prove which account owns the source cloud state.

## Restore to a tablet or new phone

1. Install/update the **PvZ 2 NA** build and launch it once so it creates the
   save directory, then **Force stop** it.
2. Turn networking genuinely off: disable Wi-Fi and mobile data, stop the VPN,
   and verify there is no active network. Airplane mode alone is insufficient.
3. Run `./scripts/import-save.sh`. It first copies the current device save to
   `No_Backup.orig`, replaces the destination contents so stale files cannot
   survive, and then pushes the repository snapshot into the clean directory.
   If the push fails, the script attempts to roll back automatically.
4. Launch the game while still offline. Verify **User Dave**, the expected
   progression, and `pp.dat` before doing anything else.
5. Keep the moved device offline while using the restored local profile. Do not
   manually link Google Play Games, EA, or another old cloud account.
6. If an online launch is ever attempted, only do so with explicit approval,
   the same credentials identified by EA, the source device inactive, a fresh
   backup, and a watchdog that force-stops and restores the game when the
   profile changes.

`import-save.sh` does not access app-private identity state and does not alter a
remote snapshot. The verified local reference `pp.dat` is 15,517 bytes with
SHA-256:

```text
c5486184205c7d952d77c83d32d742424e11711f5e41ddf818e8f6dcfc95ae5b
```

## Troubleshooting

| Symptom | Safe response |
|---|---|
| Game starts a fresh profile after restore | Verify the package is `com.ea.game.pvz2_na`, the path is `Android/data/com.ea.game.pvz2_na/files/No_Backup`, and `pp.dat` exists. Restore again offline. |
| Restored profile is empty or shows 0 coins/gems | Treat it as a possible cloud/snapshot overwrite. Force-stop immediately, keep networking disabled, restore the repository snapshot, and verify the visible profile before any network test. |
| Identity-selection or GUID conflict | Do not experiment with linked accounts on the Pad. Keep it offline and preserve the source files while support identifies the relevant account. |
| Profile collapses on an online boot | This was reproduced on direct Wi-Fi. Static APK analysis implicates Play Games Snapshots (`PvZ2-1.pvz2`), but the exact remote payload is unknown. Restore and remain offline. |
| Progress appears lost after account linking | Do not repeatedly relaunch. Force-stop, disable networking, restore the local snapshot, and contact support with the account relationship documented. |
| Game crashes while loading | Confirm the NA package and compatible game version before changing the save. Do not reinstall as the first recovery step. |

## Identity information

`1771293681` is the **local profile ID** observed in the saved profile and
profile-specific filenames. It is not guaranteed to be a Google Play Games
player ID or an EA server identifier. The value
`F9AD327B-E0B3-4244-8A9F-5D1549C8C194` was found in quest RTON data, but its
role is unverified; do not label it a GIN or rely on it alone for support.

When contacting EA or Google, provide the local ID, screenshots, package/version,
the source account email, and the exact progression. Ask which credentials their
service recognizes and how to activate the existing profile on one secondary
device; EA has said that device-to-device progress transfer is not supported.
The qualified template is in
[`docs/ea-support-email-template.md`](docs/ea-support-email-template.md).
