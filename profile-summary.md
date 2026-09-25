# PvZ 2 profile snapshot — “User Dave” (`1771293681`)

This is a summary of the **local** PvZ 2 NA save snapshot in this repository.
It was decoded from `No_Backup/` on 2026-09-22 and revalidated on the Pad on
2026-09-25.

## Profile

| Field | Value | Confidence / meaning |
|---|---|---|
| Name | User Dave | Observed in the restored game |
| Local profile ID | `1771293681` | Observed local/profile-file identifier; not proven to be a Play Games or EA login ID |
| Region build | `com.ea.game.pvz2_na` | Verified package |
| Game data version | CDN push 13.4.1 (`CDN.13.4`) | Observed in the snapshot |
| Serialized save UID | `1.0.69541402` | Value in the RTON save; not independently verified as an account identifier |
| Last source save write | 2026-09-22 (approx. 13:29) | Approximate local observation |
| Account association | Not established by this repository | The source device was observed online, but the cloud/account relationship was not identified |

`1771293681` is useful for matching the local files and for support context. It
must not be described as a universal login, Google Play Games player ID, or
confirmed EA GIN without a provider confirming that interpretation.

## Currency (at snapshot time)

- Coins: 114,990
- Gems: 1,682
- Mints: 553
- Total USD spent: $0

## Progression

- Plants tracked: 76 · plant-level entries: 56
- Last level played: `joust/melee/joust_melee_3` (Arena)
- Arena career high score: 329,300

## Purchase history (Skus, 18 entries — all $0 spend)

Gem packs (20 / 50 / 110 / 250 / 1800), 10,000 coins, Crazy Dave's Premium
Bundle, Toadstool lvl 5 pack, Parsnip lvl 5 pack, Tumbleweed bundle,
special bundle 13, PvZ2 26th-birthday costume bundle, POTW Znakelily, and
duplicate gem packs.

## Files

| File | Purpose |
|---|---|
| `pp.dat` | Main local profile (RTON) |
| `snapshot1.dat` / `snapshot2.dat` | Rolling local profile snapshots (the game alternates them) |
| `local_profiles` | Local purchase/last-use data |
| `global_save_data` + `.hash` | Unlock flags, arena records, and ad/permission preferences |
| `draper_<id>` | Arena / Penny's Pursuit history |
| `loot<id>` | Loot/piñata drop state |
| `activequests/`, `dailyquests/` | Quest state |

Most of the listed profile and quest files are PopCap **RTON** binary data; the
hash and validity-marker files are auxiliary. There is no plain JSON inside the
save. Decode tools such as `pvsz2.ru/converter/en` can be used for inspection,
but a decoder is not an account-association tool.

## Cloud and identity evidence

The local snapshot and the cloud state are separate layers. Copying
`No_Backup` does not copy an account, a player association, or a remote snapshot.

For the tested APK (`13.4.1`, build `1055`), static analysis found that startup
can call `CloudSilentSync()` after Play Games sign-in and then use the Google
Play Games Snapshots client with the fixed key:

```text
PvZ2-1.pvz2
```

A successful snapshot open is passed into the game's load path; save callbacks
write and commit a snapshot. This makes Play Games Snapshots a supported
technical explanation for the observed online collapse, but the remote payload
and account owner were not recovered. The snapshot key is not derived from
`1771293681`.

The following identifiers must not be conflated:

| Value | Observed role | Status |
|---|---|---|
| `1771293681` | Local profile ID / profile-specific filenames | Verified locally; cloud meaning unproven |
| `1.0.69541402` | Serialized save UID in `pp.dat` | Local RTON value; account meaning unproven |
| `F9AD327B-E0B3-4244-8A9F-5D1549C8C194` | String in active/daily quest RTON data | Identity role unverified; **not** labeled a GIN |
| `D1EDD3D5-C2AB-44B9-9762-B6FCA23B4805` | Logged by analytics `Tags.setUserID` | Analytics/lifecycle data, not established as a player ID |
| `D57D26AE-F6FF-4951-A1B0-22E51D5CEB23` | Logged as advertising/lifecycle ID | Not a profile or Play Games identity |

The Pad log showed Google Play Games automatically selecting an account from
installer data and handling sign-in, but the account/player values were
redacted. It did not establish which account owns `PvZ2-1.pvz2`.

## Recovery reference

The verified repository `pp.dat` is 15,517 bytes with SHA-256:

```text
c5486184205c7d952d77c83d32d742424e11711f5e41ddf818e8f6dcfc95ae5b
```

Use the hash as an exact known-good reference when restoring, while also
checking the visible name and progression: ordinary offline gameplay can change
file hashes without indicating that the profile was lost.
