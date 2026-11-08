# STATE.md — Project BUTTER

**Current gate: 0 — Bootstrap & Pipeline**
**Updated: 2026-11-08 (session 2)**

## Pipeline status

- 🟢 **GREEN** — run `42482234401` ("fix: track ios/ directory in git") on
  `main` @ `9510049` passed. **Artifact `butter-dev-ipa` exists (6,188,057 bytes).**
  - Run `42481455183` failed (expected: `flutter pub get` ran before the Flutter project existed).
  - Run `42481853314` failed (root cause: `.gitignore` was written for an XcodeGen setup, but flutter create generates the ios/ folder as the canonical structure — it must be tracked).
- Repo: https://github.com/ggogogohub/build_your_own_music (public)

## Gate 0 checklist

| Item | Status |
|---|---|
| Flutter stable installed, `flutter doctor` clean on Windows | ✅ Flutter 3.47.9 stable at `C:\Tools\flutter`, all 7 doctor categories green. PATH persisted to Windows user PATH (session 2). |
| Repo public on GitHub | ✅ https://github.com/ggogogohub/build_your_own_music — pushed 2026-11-08. |
| GitHub Actions workflow | ✅ `ios-dev.yml` triggered on all pushes; `ios-testflight.yml` dormant (workflow_dispatch only). |
| App installs and launches on iPhone via TestFlight | ✅ **Device test PASSED (2026-11-08)** — user sideloaded `butter-dev.ipa` from run `42482234401` via Sideloadly, enabled Developer Mode, app launched on iPhone. Flutter counter demo works (plus button, count increments). |
| Trivial CI change proves loop | ✅ Push → CI run `42482234401` green + artifact `butter-dev-ipa` exists. |
| gstack installed | ✅ v1.98.0.0 installed (claude host, full tier, global). Only `/cso` unavailable (PowerShell toolchain probe failed — non-critical). |
| Claude HUD active | ✅ gstack hooks registered (timeline-stop-hook re-pointed). |
| Codex configured as second reviewer | ✅ Codex CLI installed (0.167.0, `npm install -g @openai/codex`). ⏳ `codex login` pending — user must run it interactively (browser auth). |

## Done this session

- Created public repo `ggogogohub/build_your_own_music`, pushed bootstrap commit
- Persisted Flutter to Windows user PATH (`[Environment]::SetEnvironmentVariable`)
- Cloned gstack, ran `./setup` → v1.98.0.0, all skills registered
- Scaffolded Flutter app shell: `flutter create --project-name butter --org com.butterapp --platforms ios`
- `flutter analyze` clean (17.7s, no issues)
- Pushed scaffold commit `1652796` → CI run `42481853314` (failed: ios/ was gitignored)
- Fixed `.gitignore` to track ios/ → commit `9510049` → CI run `42482234401` **GREEN** with `butter-dev-ipa` artifact (6.2 MB)
- **Device test PASSED**: user sideloaded butter-dev.ipa via Sideloadly, enabled
  Developer Mode, app launched on iPhone, counter demo works.
- Installed OpenAI Codex CLI 0.167.0 (`npm install -g @openai/codex`)

## Open issues / blockers

1. **`codex login`** — user must run it interactively (browser auth) before Codex
   can act as second reviewer. Not blocking Gate 0 approval.
2. **settings.json permissions merge** — user action, pending (see below).

## Next queued task

1. **User:** run `codex login` (browser auth) to complete the second-reviewer setup.
2. **User:** merge permissions block into ~/.claude/settings.json (strict JSON).
3. Run `/office-hours` with the framing: "offline-first free iOS music player built
   from Reddit complaints — no ads, no accounts, FLAC support, Wi-Fi transfer from PC"
4. Gate 0 approval ("GATE 0 APPROVED") → then Gate 1 (audio engine)
