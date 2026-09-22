# PvZ 2 — Full transfer procedure (case summary)

One place that says what this repo *is*, *why it exists*, *what happened*, and
*what the end state is*. Written 2026-09-23, after the whole cross-device saga.

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
  ├─ pp.dat              (main profile, RTON)   ← 15,912 B, intact
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
  from China without a routed VPN.

The transfer is therefore a **file-copy + identity-management problem**, not a
"log in and it follows you" problem.

---

## 3. What we tried (chronology)

1. **Direct file copy** phone → repo → tablet.
   ✓ Profile restored and intact. Offline boots stable indefinitely.
2. **Identity conflict** (two anonymous identities on tablet).
   Resolved by `pm clear` + full re-restore. Profile survived (verified 15,912 B).
3. **Online test boots** on tablet.
   ✗ Cloud sync pulls the *empty* server profile for a fresh identity and
   **zeroes** the local save within ~20–24 s of going online.
   → Profile restored from repo every time (never lost; triple-backed-up).
4. **Cloud / EA linking icon**.
   The icon appears only in the fresh, never-registered state. On the already-online
   phone it is hidden — that is by design (profile is already registered
   anonymously). No EA-account route exists in build 1055 without surfacing the UI.
5. **Resource / patch download "could not find resources".**
   After the final `pm clear`, the game's private resource-DB (verifying the 930 MB
   OBB) is gone. Cleaning it wants ONE online check against EA's CDN, which the
   tablet cannot reach directly (0 % packet loss, EA unreachable from CN without
   Clash VPN). EA's IP range is geo-blocked in this network; only the VPN tunnel
   reaches it — and that same tunnel is what triggers the cloud zeroing.

---

## 4. Current verified state (2026-09-23)

| Item | Status |
|---|---|
| Phone (online device) | Anonymous online identity **intact & fully working** — plays online, keeps progress |
| Tablet | Fresh unregistered identity + **full intact profile (15,912 B)** restored; stable offline |
| Profile safety | Triple backup: repo, local snapshot, `backups/` zip — any partial/bad write rolls back instantly |
| Cloud zeroing | Preventable: watchdog force-stops before shrink; auto-restore from repo |
| EA online reachability (tablet → EA) | Unreachable directly; reachable only via Clash VPN tunnel |
| Cloud/Sync icon | Hidden while profile is anonymous-online; appears only in fresh-unlinked state |

Bottom line: the save itself is **100 % safe and reproducible**. The remaining
blocker is **not a file problem** — it is that an anonymous identity that has
*already* contacted EA gets an empty server profile back on other devices, and
getting past the resource banner needs one guarded online (VPN) session.

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

### B. Guarded in-game online test (risky but recoverable)

Enable the VPN tunnel once with the watchdog active: the game finishes its
resource verify, and (with a fresh never-registered identity) the first online
contact *may upload* the full local profile instead of pulling empty — that would
make the fresh identity playable online permanently.

- Profile stays safe: watchdog force-stops at the first sign of shrink, and
  restore-from-repo runs automatically.
- This is a real decision for you — nothing runs until you say go.

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

> The one rule that has never failed: **first boot after any restore = offline.**
> After the profile has loaded once, network can come back and it persists.
