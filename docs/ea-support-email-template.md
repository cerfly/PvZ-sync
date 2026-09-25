# EA / Google Support — Request official PvZ2 account association or migration

This is a deliberately qualified support request. It does **not** claim that a
local ID or a GUID found in a quest file is a confirmed EA GIN, and it does not
promise that EA or Google can perform a particular migration.

Copy the appropriate ticket below, replace the placeholders, and send it through
the official EA Help / PvZ2 contact channel. A Google Play Games question may
also need to be sent to Google Play support; the provider that owns the
`PvZ2-1.pvz2` snapshot may be able to answer only that part.

---

## Information to provide

| Field | Value / instruction |
|---|---|
| Game | Plants vs. Zombies 2 (North America) |
| Platform | Android |
| Package | `com.ea.game.pvz2_na` |
| Game version | 13.4.1, build 1055 |
| Player name | User Dave |
| Local profile ID | `1771293681` — observed in the local save; not claimed to be a login ID |
| Serialized save UID | `1.0.69541402` — observed in RTON; not claimed to be an account ID |
| Source Google account | `SOURCE_GOOGLE_EMAIL` — the account used on the working phone |
| EA account | `EA_ACCOUNT_EMAIL_OR_NONE` |
| Progression | 114,990 coins; 1,682 gems; mints 553; last level `joust/melee/joust_melee_3`; Arena high score 329,300 |
| Second device | Android Pad; same NA package; restored local files and kept offline |
| Diagnostic snapshot key | `PvZ2-1.pvz2` — fixed key observed in the tested APK; not an account ID |

### Unverified clue — do not present as a GIN

`F9AD327B-E0B3-4244-8A9F-5D1549C8C194` occurs in active/daily quest RTON data.
Its identity role has not been established. It may be included only as an
explicitly labeled observation if support asks for all available identifiers:

> “This GUID was found in quest data, but we do not know whether it is an EA
> player identifier. Please confirm whether it is meaningful to your service.”

Do not send passwords, OAuth tokens, private app databases, or unredacted logs.

---

## English ticket

**Subject:** `PvZ2 NA Android — identify and migrate existing progress`

**Body (837 characters before replacing placeholders; keep the submitted ticket under 1,000 characters):**

```text
Hello,

I play PvZ2 NA on Android. My source phone has a working profile, and I want to use the same progress on a second Android device without overwriting the source save.

Please advise the official way to identify, associate, or migrate this profile. Please confirm which ID you recognize (local ID 1771293681, EA/Google account, or another ID), what service owns snapshot PvZ2-1.pvz2, and whether migration to another device is possible.

Details: User Dave; com.ea.game.pvz2_na; v13.4.1 build 1055; 114,990 coins, 1,682 gems, 553 mints. Source Google: SOURCE_GOOGLE_EMAIL. EA: EA_ACCOUNT_EMAIL_OR_NONE.

The local save restored successfully offline. I will keep the second device offline and will not link accounts without your instructions. Please do not delete or overwrite the source save. I can provide screenshots.

Thank you.
```

---

## 中文工单

**主题：** `PvZ2 美服 Android——确认并迁移现有进度`

**正文（替换占位符后仍请控制在 1,000 字符以内）：**

```text
您好，我在 Android 上玩 PvZ2 美服。源手机上的进度完整，我想在第二台 Android 设备继续使用，不想覆盖源存档。

请确认官方的识别、关联或迁移方式：您使用哪个 ID（本地 ID 1771293681、EA/Google 账号或其他 ID）；进度是否关联 Google Play Games、EA 或匿名记录；能否迁移到第二台设备；以及快照键 PvZ2-1.pvz2 由哪一方管理。

信息：User Dave；包名 com.ea.game.pvz2_na；版本 13.4.1 build 1055；金币 114,990、宝石 1,682、代币 553；源 Google 账号：SOURCE_GOOGLE_EMAIL；EA 账号：EA_ACCOUNT_EMAIL_OR_NONE。

本地存档已在断网的第二台设备成功恢复。我会保持离线，不会在未获方案前绑定账号。请不要删除或覆盖源存档。我可以提供截图。谢谢！
```

---

## Before sending

- [ ] Replace `SOURCE_GOOGLE_EMAIL` and `EA_ACCOUNT_EMAIL_OR_NONE`.
- [ ] Attach a source-device screenshot showing the name, coins, gems, and
      relevant progression; remove unrelated personal information.
- [ ] Include the package and version exactly as written above.
- [ ] State whether the source account was explicitly linked, anonymously
      registered, or selected automatically by the installer. Do not guess.
- [ ] Keep the second device offline. Do not test a link on the Pad while the
      source save is the only verified copy.
- [ ] Keep the case number and reply in the same thread.
- [ ] If asked for the GUID found in quest data, label it **unverified** and ask
      whether EA recognizes it; do not call it a GIN yourself.

## If support gives a generic answer

Ask for the exact provider and identifier needed for an **existing-record
association or migration**, not for a new anonymous profile. A useful follow-up
is:

> “I do not want to create a new anonymous player or overwrite my source save.
> Please confirm whether support can inspect the existing player record for the
> source account, or whether this requires a Google Play Games snapshot
> migration. What is the safe order of operations, and what should I preserve
> before testing?”
