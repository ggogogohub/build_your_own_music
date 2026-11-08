# STATE.md — Project BUTTER

**Current gate: 0 — Bootstrap & Pipeline**
**Updated: 2026-11-08 (session 2)**

## Pipeline status

- 🟡 **IN PROGRESS** — run `42481853314` ("feat: scaffold Flutter app shell") on
  `main` @ `1652796` is running now. First run `42481455183` failed
  (expected: `flutter pub get` ran before the Flutter project existed).
- Repo: https://github.com/ggogogohub/build_your_own_music (public)

## Gate 0 checklist

| Item | Status |
|---|---|
| Flutter stable installed, `flutter doctor` clean on Windows | ✅ Flutter 3.47.9 stable at `C:\Tools\flutter`, all 7 doctor categories green. PATH persisted to Windows user PATH (session 2). |
| Repo public on GitHub | ✅ https://github.com/ggogogohub/build_your_own_music — pushed 2026-11-08. |
| GitHub Actions workflow | ✅ `ios-dev.yml` triggered on both pushes; `ios-testflight.yml` dormant (workflow_dispatch only). |
| App installs and launches on iPhone via TestFlight | ❌ Pending — dev builds go through Sideloadly until Gate 5; needs user's device test of the butter-dev.ipa artifact. |
| Trivial CI change proves loop | 🟡 Scaffold push is the loop proof; awaiting green run + artifact. |
| gstack installed | ✅ v1.98.0.0 installed (claude host, full tier, global). Only `/cso` unavailable (PowerShell toolchain probe failed — non-critical). |
| Claude HUD active | ✅ gstack hooks registered (timeline-stop-hook re-pointed). |
| Codex configured as second reviewer | ❌ Not yet — `codex` skill available but needs config check. |

## Done this session

- Created public repo `ggogogohub/build_your_own_music`, pushed bootstrap commit
- Persisted Flutter to Windows user PATH (`[Environment]::SetEnvironmentVariable`)
- Cloned gstack, ran `./setup` → v1.98.0.0, all skills registered
- Scaffolded Flutter app shell: `flutter create --project-name butter --org com.butterapp --platforms ios`
- `flutter analyze` clean (17.7s, no issues)
- Pushed scaffold commit `1652796` → CI run `42481853314` triggered

## Open issues / blockers

1. **CI run 42481853314** — awaiting result; if green with butter-dev.ipa artifact,
   Gate 0's "trivial CI change proves loop" item is satisfied.
2. **settings.json permissions merge** — blocked by the local self-modification guard.
   The user needs to add the permissions block manually (see below).
3. **Codex as second reviewer** — not yet configured.

## Next queued task

1. Confirm CI run 42481853314 green + butter-dev.ipa artifact exists
2. User: download butter-dev.ipa, sideload via Sideloadly, verify launch
3. User: merge permissions block into ~/.claude/settings.json (strict JSON, no comments)
4. Run `/office-hours` with the framing: "offline-first free iOS music player built
   from Reddit complaints — no ads, no accounts, FLAC support, Wi-Fi transfer from PC"
5. Gate 0 approval → then Gate 1 (audio engine)
