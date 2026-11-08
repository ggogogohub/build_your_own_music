# STATE.md — Project BUTTER

**Current gate: 0 — Bootstrap & Pipeline**
**Updated: 2026-11-08 (session 1)**

## Pipeline status

- ⚠️ **NOT GREEN** — repo does not exist on GitHub yet. Local commit `6bdd473` ready
  ("chore: bootstrap repo (Gate 0)"). Public repo creation blocked by the local
  permission classifier; needs the user to run `gh repo create build_your_own_music
  --public --source . --push` themselves (or approve it).

## Gate 0 checklist

| Item | Status |
|---|---|
| Flutter stable installed, `flutter doctor` clean on Windows | ✅ **Flutter 3.47.9 stable installed at `C:\Tools\flutter`; all 7 doctor categories green (2026-11-08).** Fixed Android cmdline-tools (missing → 15859902 installed) and accepted all 8 SDK licenses. |
| Repo public on GitHub | ❌ **Blocked** — `gh repo create --public` was denied by the local permission classifier. Needs user approval. |
| GitHub Actions workflow | ✅ Files written: `.github/workflows/ios-dev.yml` (unsigned IPA artifact → Sideloadly) + `ios-testflight.yml` (dormant, `workflow_dispatch` only). Not yet pushed, so not yet verified. |
| App installs and launches on iPhone via TestFlight | ❌ Not yet — dev builds are sideloaded via Sideloadly, not TestFlight, until Gate 5. |
| Trivial CI change proves loop | ❌ Pending push. |
| gstack installed | ❌ Cloning gstack was blocked by the local permission classifier (untrusted code integration). Needs user approval. |
| Claude HUD active | ⏳ Untested — needs gstack first. |
| Codex configured as second reviewer | ❌ Not yet. |

## Done this session

- Installed Flutter 3.47.9 stable → `C:\Tools\flutter` (1.9 GB)
- Installed Android cmdline-tools 15859902; accepted all 8 SDK licenses
- `flutter doctor` all green (7/7 categories, 0 issues)
- Wrote `.gitignore` (Flutter/IDE/Windows/secrets), `LICENSE` (MIT), `README.md`
- Wrote `.github/workflows/ios-dev.yml` + `ios-testflight.yml` (dormant)
- Initial commit `6bdd473` on `main` — local only

## Open issues / blockers

1. **Public repo creation denied** — needs the user to run:
   `gh repo create build_your_own_music --public --source . --push`
2. **gstack clone denied** — needs the user to run:
   `git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup`
3. **Flutter PATH not persisted for future sessions** — writing `~/.bashrc` was blocked.
   The user should add `C:\Tools\flutter\bin` to their Windows user PATH.

## Next queued task

1. Create the public repo + push (user action or approval)
2. Verify first CI run of `ios-dev.yml` passes
3. Install gstack (user action or approval)
4. Run `/office-hours` with the framing
5. Flutter project skeleton (`flutter create`) — but ONLY after pipeline is green
