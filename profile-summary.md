# PvZ 2 profile snapshot — "User Dave" (1771293681)

Decoded from the save files (`No_Backup/`) on 2026-09-22.

## Profile

| Field | Value |
|---|---|
| Name | User Dave |
| Player / profile ID | 1771293681 |
| Region build | `com.ea.game.pvz2_na` (North America) |
| Game data version | CDN push 13.4.1 (`CDN.13.4`) |
| Save internal uid | 1.0.69541402 |
| Last save write | 2026-09-22 (approx. 13:29) |
| Account linking | never done / never offered — local-only save |

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
| `pp.dat` | main profile (RTON) |
| `snapshot1.dat` / `snapshot2.dat` | rolling profile snapshots (game alternates them) |
| `local_profiles` | purchase/last-use local data |
| `global_save_data` + `.hash` | unlock flags, arena records, ad/permission prefs |
| `draper_<id>` | arena / Penny's Pursuit history |
| `loot<id>` | loot/piñata drop state |
| `activequests/`, `dailyquests/` | quest state |

All files are PopCap **RTON** binary format — there is no plain JSON inside the
save; decode tools (e.g. `pvsz2.ru/converter/en`) can dump them for inspection.