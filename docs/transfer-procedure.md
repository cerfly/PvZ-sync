# PvZ 2 — Full transfer procedure (case summary)

One place that says what this repo *is*, *why it exists*, *what happened*, and
*what the end state is*. Written 2026-09-23; revalidated on the Android Pad on
2026-09-25.

---

## 1. Goal

Keep the intact, fully-progressed PvZ 2 NA profile — player **"User Dave"**
(profile id `1771293681`, 114,990 coins · 1,682 gems) — and be able to keep
playing it **online**, and ideally on a **second device** (tablet) with the
same progress.

Everything in this repo is in service of that single goal.

---

## 2. The technical reality (why this is hard)

PvZ 2 on Android stores the entire profile inside the app's private
`No_Backup` folder:

```
/sdcard/Android/data/com.ea.game.pvz2_na/files/No_Backup/
  ├─ pp.dat              (main profile, RTON)   ← 15,517 B, intact
  ├─ snapshot1/2.dat     (rolling profile snapshots)
  ├─ local_profiles      (purchase / local-use data)
  ├─ activequests/ , dailyquests/ , loot* , draper_*
  └─ global_save_data (+ .hash)
```

That folder **is** the save — there is no other copy. Official cloud save is
available, but it is keyed to:

- an **anonymous per-install identity** (GIN, an install-scoped GUID)
  registered with EA's servers, **not** to a file;
- **Google Play Games / EA account** linking — which is *not currently reachable*
  from China without a routed VPN. The direct-Wi-Fi test nevertheless reached
  enough of the Google Play Games sync path to trigger the overwrite.

The transfer is therefore a **file-copy + identity-management problem**, not a
"log in and it follows you" problem.

---

## 3. What we tried (chronology)

1. **Direct file copy** phone → repo → tablet.
   ✓ Profile restored and intact. Offline boots stable indefinitely.
2. **Identity conflict** (two anonymous identities on tablet).
   Resolved by `pm clear` + full re-restore. Profile survived (verified 15,517 B).
3. **Online test boots** on tablet.
   ✗ Cloud/Play Games sync pulls the *empty* server profile for a fresh identity
   and **zeroes** the local save. The 2026-09-25 direct-Wi-Fi test observed the
   collapse within 8 seconds, even without Clash/VPN.
   → Profile restored from repo every time (never lost; triple-backed-up).
4. **Cloud / EA linking icon**.
   The icon appears only in the fresh, never-registered state. On the already-online
   phone it is hidden — that is by design (profile is already registered
   anonymously). No EA-account route exists in build 1055 without surfacing the UI.
5. **Resource / patch download "could not find resources".**
   After the final `pm clear`, the game's private resource-DB (verifying the 930 MB
   OBB) is gone. Cleaning it wants one online check against EA's CDN, which the
   tablet cannot reach directly from this network. Clash can reach the CDN, but it
   is not required to trigger the profile overwrite.
6. **Revalidation on the Android Pad (2026-09-25).**
   The first apparent offline launch was not actually offline: Android reported
   `airplane_mode_on=1`, but Wi-Fi and Clash's `tun0` VPN were still active. After
   force-stopping Clash, disabling Wi-Fi and mobile data, and confirming that
   `wlan0` was down and ping reported `Network is unreachable`, the repository save
   loaded as full **User Dave** and stayed intact for at least 90 seconds.
   A guarded launch using direct Wi-Fi with **no VPN** then collapsed the profile
   within 8 seconds. The logcat capture showed Google Play Games
   `SignInPerformer` and `CloudSilentSync`; no manual account linking was done,
   but the Pad's Play Games stack was already handling an installer-selected
   account. The watchdog force-stopped the game, disabled networking, and
   restored the exact 15,517-byte snapshot.

---

## 4. Current verified state (2026-09-25)

| Item | Status |
|---|---|
| Phone (online device) | Anonymous online identity **intact & fully working** — plays online, keeps progress |
| Tablet | Fresh unregistered identity + **full intact profile (15,517 B)** restored; stable offline |
| Profile safety | Triple backup: repo, local snapshot, `backups/` zip — any partial/bad write rolls back instantly |
| Cloud zeroing | Confirmed on direct Wi-Fi without a VPN: profile collapsed in 8s; watchdog force-stopped and auto-restored from repo |
| EA online reachability (tablet → EA) | Unreachable directly; reachable only via Clash VPN tunnel. Direct Wi-Fi is nevertheless sufficient for the Play Games/cloud overwrite path. |
| Cloud/Sync icon | Hidden while profile is anonymous-online; appears only in fresh-unlinked state |

Bottom line: the save itself is **100 % safe and reproducible**. The remaining
blocker is **not a file problem** — it is the per-install identity/cloud-sync
boundary. A moved-to device can play the full profile offline, but any reachable
network sync path can replace it with the moved install's empty profile. Keep the
Pad offline unless EA account linking is resolved.

---

## 5. The two paths forward

### A. Support-assisted email linking (recommended, no risk to the save)

File a ticket with EA support (help.ea.com → PvZ 2 → Contact us) asking them to
link an EA email to your existing anonymous player identity. EA is the only party
that can attach the *server-side* anonymous record to a real email, which is what
makes the same save playable online on the tablet.

- Prepared template (EN + 中文), player prefix, GIN, and proof-of-ownership
  checklist: → `docs/ea-support-email-template.md`
- Attach proof (profile overview + coin/gem counts) and the GIN so they can
  verify rather than reply "we can't find anonymous accounts".

### B. Guarded in-game online test (completed; recoverable but not a solution)

The guarded test was run on 2026-09-25. With direct Wi-Fi and no VPN, the
Play Games/cloud path still replaced the restored profile within 8 seconds.
The watchdog force-stopped PvZ 2 and restored the repository snapshot, so the
save remained safe; however, the test disproved the idea that a VPN might make
the Pad adopt the source phone's online identity.

- Do not repeat this test merely to make the Pad online.
- Keep the Pad offline, or pursue EA support-assisted account linking first.

---

## 6. Files in this repo

| Path | Purpose |
|---|---|
| `README.md` | Transfer overview + the offline-first gotcha + how to export/import |
| `profile-summary.md` | Decoded profile details (id, coins, gems, plants, history) |
| `docs/ea-support-email-template.md` | EA ticket (EN + 中文) to link an email to the anonymous profile |
| `scripts/export-save.sh` | Pull save from device → repo |
| `scripts/import-save.sh` | Push repo save → device (restore) |
| `saves/` | The actual save snapshot (RTON files) |
| `backups/` | Zipped recovery snapshot |

---

## 7. Restore / rollback cheatsheet

```bash
# export from a device into repo (phone serial optional):
./scripts/export-save.sh            # one device
./scripts/export-save.sh <serial>   # specific device

# import repo save onto a device:
#  (1) Force-stop the game
#  (2) keep the device OFFLINE for the FIRST boot after restore
./scripts/import-save.sh            # one device
./scripts/import-save.sh <serial>   # specific device

# full rollback: restore backup zip over a bad/broken state
# (backup of last good state lives in backups/)
```

> The one rule that has never failed: **first boot after any restore = genuinely offline.**
> After the profile has loaded once, keep the moved device offline; a reachable
> network sync path can still overwrite it.
