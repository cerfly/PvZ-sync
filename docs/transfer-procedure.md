# PvZ 2 — Full transfer procedure (case summary)

This document records the evidence, limits, and safe recovery procedure for moving
**Plants vs. Zombies 2 NA** progress from one Android install to another. It was
last revalidated on the Android Pad on **2026-09-25**; the APK findings below come
from the tested NA build **13.4.1 (build 1055)**.

> **Safety rule:** keep the moved-to Pad offline until an account-association plan
> has been confirmed by EA or Google. Airplane mode alone is not a sufficient
> offline test. Do not manually link Google Play Games or EA accounts on the Pad
> during recovery.

---

## 1. Goal

Preserve the intact PvZ 2 NA profile — player **“User Dave”**, local profile ID
`1771293681` — and, if EA/Google can establish a supported account association,
continue the same progress on a second Android device.

The repository is an evidence-preserving local-file backup. It is **not** a copy
of the account database, the Google Play Games account, or the remote snapshot.

---

## 2. What is actually being transferred

The tested game stores the local profile in the app's public Android-data area:

```text
/sdcard/Android/data/com.ea.game.pvz2_na/files/No_Backup/
  ├─ pp.dat                 main profile (RTON; 15,517 bytes in this snapshot)
  ├─ snapshot1.dat
  ├─ snapshot2.dat          rolling profile snapshots
  ├─ local_profiles         local/purchase-use data
  ├─ global_save_data (+ .hash)
  ├─ draper_1771293681      arena/Penny's Pursuit history
  ├─ loot1771293681
  └─ activequests/ , dailyquests/
```

`No_Backup` contains local game data only. Copying it does **not** copy:

- the Google account selected by Android or the installer;
- a Google Play Games player association;
- the Play Games snapshot stored in Google's service; or
- any server-side EA player record.

The numeric value `1771293681` is the **local profile identifier** used by the
saved profile and related profile-specific files. It is not, by itself, proof of
a Google Play Games player ID, an EA account, or a server-side GIN.

### APK evidence: the online load/save route

Static analysis of the tested APK established this startup sequence:

1. `SexyAppFrameworkActivity.launchGame()` calls `GameHelperActivityReady()` and
   then `CloudSilentSync()`.
2. `CloudSilentSync()` proceeds through the silent-sync path when Play Games
   sign-in has succeeded.
3. `GameHelper.attemptSilentSyncInternal()` obtains a Play Games
   `SnapshotsClient` and opens the fixed snapshot name:

   ```text
   PvZ2-1.pvz2
   ```

4. The successful-open path calls `tryToOpenSnapshot()`, reads the returned
   contents with `SnapshotContents.readFully()`, and then calls
   `doLoad()` / `Native_CloudStateLoaded`.
5. The save path writes a snapshot and calls `commitAndClose()`.

This is strong evidence that **Google Play Games Snapshots is a viable local-state
overwrite path**. It does **not** prove which remote state was returned during the
Pad test. The captured evidence cannot yet distinguish a missing snapshot, an
empty snapshot, a snapshot owned by a different Google account, or a snapshot
that had previously been overwritten. Nor does it establish an EA cloud-save API
or a server-side mapping to any particular GUID.

---

## 3. What was tried

### 3.1 Offline file restore — verified

1. The source `No_Backup` snapshot was copied to this repository.
2. The Pad's existing save was backed up before the push.
3. Networking was genuinely disabled: Wi-Fi and mobile data were off, the VPN
   was stopped, `wlan0` was down, and a connectivity check reported no network.
4. The imported files loaded, including `pp.dat`, `local_profiles`,
   `draper_1771293681`, snapshots, and quest files.
5. **User Dave** appeared with the expected progression. `pp.dat` was 15,517
   bytes and the profile remained intact for at least 90 seconds.

The final verified repository copy had SHA-256:

```text
c5486184205c7d952d77c83d32d742424e11711f5e41ddf818e8f6dcfc95ae5b
```

A hash change after ordinary offline gameplay is not by itself proof of loss;
the important checks are the player name, progression, file size, and a valid
profile load. The hash above is the exact known-good restore reference.

### 3.2 Direct Wi-Fi startup — unsafe and repeatable

A guarded startup with direct Wi-Fi and no VPN caused the restored profile to
collapse to an empty/fresh state within about eight seconds. The watchdog
force-stopped PvZ 2, disabled networking, and restored the exact repository
snapshot. No source-device save was modified.

The log showed, in order:

- Android/Play Store selecting an account from installer data;
- Google Play Games sign-in (`SignInPerformer`);
- player lookup and authorization (`PlayerManager`);
- `GameHelperActivityReady` followed by `CloudSilentSync`; and
- the app loading the local `pp.dat` and related files.

The account and player values were redacted in the capture. No manual Play Games
or EA linking was performed. This proves that an installer-associated Google
account was being handled automatically, but it does not identify which account
owns the `PvZ2-1.pvz2` snapshot or prove the exact cloud write event.

### 3.3 Failed or unproven paths

- The GUI account/cloud icon was not a reliable way to identify or migrate the
  profile; no supported association has been completed.
- The observed GUID `F9AD327B-E0B3-4244-8A9F-5D1549C8C194` occurs in active and
  daily quest RTON data. Its identity role is **unverified**. It must not be
  described as an EA GIN or used as the sole proof of ownership.
- The log also contains analytics/lifecycle identifiers. They are not the local
  profile ID and should not be submitted as player identity evidence.
- Direct EA/CDN reachability and an EA account migration endpoint were not
  established. A VPN is not a solution to the account association problem.

---

## 4. Current verified state

| Item | Status |
|---|---|
| Source device | The online source profile was observed intact during the investigation. Its cloud/account relationship is not fully identified. |
| Pad local save | The repository snapshot restored **User Dave** and was stable offline for at least 90 seconds. |
| `pp.dat` reference | 15,517 bytes; SHA-256 `c5486184205c7d952d77c83d32d742424e11711f5e41ddf818e8f6dcfc95ae5b`. |
| Online Pad startup | Profile collapse was observed on direct Wi-Fi. Play Games Snapshots is implicated by the APK and logs; the exact remote payload is unproven. |
| Remote snapshot owner | Unknown. `PvZ2-1.pvz2` is the fixed key, not an account ID. |
| EA/Google migration | No server-side association or migration has been completed. |
| Last known safe action | Keep the Pad offline and force-stopped; restore from the repository before any further test. |

Bottom line: the local save is reproducible and protected. The remaining issue
is account/cloud association, not a missing or corrupt `pp.dat`. Do not treat a
successful offline load as permission to go online.

---

## 5. Safe next steps

### A. Ask EA/Google for an official association (recommended)

Open a support case and ask whether EA can:

- identify the online player record associated with the source account;
- associate that record with an EA account or a different Google Play Games
  account; and
- migrate or restore the progress for the NA Android package.

Provide screenshots, package/version, the local profile ID, the source account
email, and the exact progression. Describe `1771293681` as a **local profile ID**,
not as a guaranteed EA/Play Games identifier. Mention the fixed snapshot name
`PvZ2-1.pvz2` as diagnostic information, but do not claim that Google or EA can
read it without their own tools. Do not present `F9AD...` as a verified GIN.

A prepared, deliberately qualified ticket is in
[`docs/ea-support-email-template.md`](ea-support-email-template.md).

### B. Identify the source cloud account without changing the source save

On the source device/account, determine which Google account is associated with
PvZ 2 and which account, if any, owns its Play Games snapshot. Record that
information without deleting snapshots, unlinking accounts, or reinstalling the
game. The Pad must remain offline during this investigation.

### C. Controlled online test — future, explicit approval only

Do not run another online launch merely to test the Pad. If the user explicitly
approves a later experiment, first:

1. force-stop PvZ 2 and take a fresh backup of the known-good repository state;
2. disable Wi-Fi, mobile data, and VPN;
3. arrange a genuinely Play-Games-isolated test environment (or a demonstrably
   account-free environment) rather than merely changing a local setting;
4. enable a watchdog that force-stops the game and restores the snapshot on any
   unexpected profile change; and
5. capture logs and snapshot metadata without exposing account tokens.

This test is diagnostic only. It is not a migration procedure.

---

## 6. Restore and rollback procedure

1. Force-stop PvZ 2 on the destination.
2. Disable Wi-Fi, mobile data, and the VPN. Verify there is no active network;
   airplane mode alone is not enough.
3. Back up the destination's current `No_Backup` directory.
4. Restore the repository snapshot to:

   ```text
   /sdcard/Android/data/com.ea.game.pvz2_na/files/No_Backup/
   ```

5. Launch once while still offline.
6. Verify **User Dave**, the expected coins/gems/progression, and the restored
   `pp.dat` before doing anything else.
7. If the profile changes unexpectedly, force-stop immediately, keep networking
   disabled, restore again, and verify the reference hash/size and visible
   progression.

`./scripts/import-save.sh` is a convenience exact-file restore. It backs up the
current destination to `No_Backup.orig`, clears the destination directory, and
pushes the repository snapshot. If the push fails, it attempts to restore the
backup automatically. It does not touch app-private identity state or the
remote Play Games snapshot.

The one rule that has not failed:

> **First boot after any restore = genuinely offline. Keep the moved device
> offline until an account-association solution is independently verified.**
