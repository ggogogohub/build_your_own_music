# CLAUDE.md — Project BUTTER (iOS Music App)

Working codename: BUTTER (rename-able). A free-forever, offline-first iOS music player
built from real Reddit/App Store complaints. Flutter, vibe-coded with Claude Code,
developed on Windows, compiled on cloud Macs.

---

## 0. NON-NEGOTIABLE CONSTITUTION

These rules override any conflicting instruction. If a request violates one, STOP and
flag it to the user before doing anything.

1. No ads. No ad SDKs, no "rewarded" anything. Ever.
2. No accounts, no sign-up, no email collection. The app works fully offline, anonymously.
3. No tracking or analytics SDKs. Sentry is the ONLY telemetry (crash reports, no PII),
   and it must be behind the privacy manifest.
4. Free forever: no IAP, no subscriptions, no feature paywalls.
5. Code license: MIT. NEVER copy code from GPL-licensed reference apps (namida,
   harmonoid) — study their architecture, write original code.
6. No streaming-from-YouTube or piracy-adjacent features (Musi was pulled from the
   App Store for this). Content = user's own files only.
7. Performance is a feature: 120fps ProMotion-capable UI, cold start < 1.5s,
   zero visible jank on library scroll. This is checked at every gate.
8. Every complaint in the backlog came from a real Reddit/App Store complaint.
   Never invent features that don't map to a documented complaint.

---

## 1. GATED EXECUTION PROTOCOL (HARD RULES)

Work proceeds through 6 gates. You are FORBIDDEN from starting work on Gate N+1
until ALL of these are true:

- Every checklist item in Gate N is verified, with evidence attached in STATE.md
  (CI run URL, TestFlight build number, device test result, or screenshot described).
- The CI pipeline (GitHub Actions macOS build -> sign -> TestFlight upload) is green
  at HEAD of main.
- The user has replied with the exact approval phrase: "GATE N APPROVED".

If the pipeline breaks: STOP feature work immediately. Fixing the pipeline outranks
all other work. Never pile feature code on top of a broken pipeline — one broken
thing at a time.

At session START: read this file + STATE.md. Report current gate, pipeline status,
and next queued task BEFORE doing any work.
At session END: update STATE.md (what shipped, evidence, open issues, next step).

---

## 2. THE GATES

### GATE 0 — Bootstrap & Pipeline (no features until green)
- [ ] Flutter stable installed, `flutter doctor` clean on Windows
- [ ] Repo public on GitHub (free macOS runner minutes), MIT license, .gitignore
- [ ] GitHub Actions workflow: macOS runner + XcodeGen -> build -> code sign -> TestFlight
- [ ] App installs and launches on the user's iPhone via TestFlight
- [ ] A trivial CI change (README edit) proves the full loop end-to-end
- [ ] gstack installed; Claude HUD active; Codex configured as second reviewer
Approval: user confirms app visible on their iPhone home screen.

### GATE 1 — Audio Engine (the #1 Reddit complaint category)
- [ ] just_audio + audio_service integrated: play, pause, seek, skip
- [ ] Background playback survives 10 min locked screen (device-verified)
- [ ] Lock screen + Control Center controls work (now-playing artwork shown)
- [ ] Interruption handling correct (phone call pauses, resumes after)
- [ ] Battery drain test: < 5% per hour of playback on the user's iPhone
- [ ] Formats verified on device: MP3, FLAC, ALAC, WAV; gapless between tracks
Evidence: TestFlight build # + user's written device test result.

### GATE 2 — Library & Import
- [ ] Files app import (file_picker) into app sandbox
- [ ] Wi-Fi transfer: in-app HTTP server (shelf), QR code to http://<phone-ip>:8080,
      browser drag-drop upload, LAN only, auto-off when leaving screen, no internet exposure
- [ ] Metadata reader: tags (title/artist/album/artwork) extracted for all formats
- [ ] Library persists across restarts; rescan is incremental, never re-reads unchanged files
- [ ] 1,000-song stress test: library screen scroll holds 60fps+ (profile mode dump attached)

### GATE 3 — UI/UX (the "buttery" gate)
- [ ] DESIGN_TOKENS.md exists (from Stitch/Figma, Phase 2) and every screen uses ONLY
      tokens from it — no ad-hoc colours, fonts, or spacing in code
- [ ] 8 screens complete: Library, Artists, Albums, Playlists, Now Playing, Mini Player,
      Import/Wi-Fi, Settings
- [ ] Mini-player drag gestures are spring-based and hit 120fps on device
- [ ] Accessibility pass (labels, contrast, dynamic type) — axe-core-equivalent sweep
- [ ] Dark mode + system-light mode both pixel-clean
Evidence: per-screen screenshots + a recorded scrolling capture described in STATE.md.

### GATE 4 — Playlists & Polish
- [ ] Create/reorder/delete playlists, long-press batch add
- [ ] Queue management: up next, shuffle, repeat-one/all
- [ ] Search across title/artist/album, debounced, instant (<100ms on 1k songs)
- [ ] Empty states and first-run onboarding (2 screens max, no permission walls)

### GATE 5 — Pre-Launch
- [ ] Codex full-codebase review completed; all criticals resolved
- [ ] Sentry wired + privacy manifest accurate (App Store requirement)
- [ ] App icon + screenshots built (Canva), listing copy cites the Reddit complaints
- [ ] Apple Developer Program enrolled ($99) — ONLY after this point
- [ ] Beta TestFlight shown to 5+ external testers; crash-free rate > 99% for 7 days
- [ ] App Store submission metadata complete; review notes explain offline nature

---

## 3. ARCHITECTURE BRIEF

- Stack: Flutter (Dart) + just_audio + audio_service + file_picker + shelf +
  Riverpod (state) + go_router. Local DB: drift or isar for library index.
- Structure: feature-first folders (lib/features/player, /library, /import, /playlists).
  Each feature folder owns its UI + logic; shared code in lib/core only.
- Audio pipeline: single AudioPlayer instance owned by an AudioHandler; UI never
  talks to just_audio directly.
- CI: GitHub Actions `macos-latest` runner, XcodeGen generates project from
  project.yml (never commit .xcodeproj), match/bundled certs for signing,
  fastlane upload to TestFlight.
- Windows constraint: zero local iOS tooling expected. ALL macOS steps live in CI.
  Verify freshness with Context7 before writing code against any package API.

---

## 4. PRODUCT SPEC (complaint-derived backlog)

| # | Complaint (source: Reddit/App Store 1-star reviews) | Requirement |
|---|------------------------------------------------------|-------------|
| 1 | Ads every few songs, crippled free tiers | Zero ads/IAP, constitution rule 1/4 |
| 2 | Background playback flaky in free apps | Gate 1 background + interruption tests |
| 3 | VLC works but UI is dated; pretty players are paid | Gate 3 token-driven premium UI |
| 4 | FLAC/lossless missing in free players | MP3/FLAC/ALAC/WAV at launch |
| 5 | Apps demand accounts, harvest data | No sign-up, offline metadata only |
| 6 | Moving music from PC to iPhone is painful | Wi-Fi transfer + Files import (Gate 2) |
| 7 | Lock-screen controls missing artwork/seek | Full NowPlayingInfo integration |
| 8 | Apps lag with big libraries | 1k-song 60fps stress test (Gate 2) |

Wi-Fi transfer spec (approved feature):
- Server binds to LAN interface only, port 8080, single-threaded upload queue.
- Screen shows URL + QR; server auto-stops on screen exit or 5 min idle.
- Uploaded files land directly in app documents; metadata indexed on receive.
- No auth needed (LAN-only), but show a "server active" banner while running.

---

## 5. DEFINITION OF DONE (applies to every task)

1. Code written, formatted, zero analyzer warnings.
2. Feature verified on the real iPhone via TestFlight build, not just "it compiles".
3. No performance regression vs the gate budget.
4. STATE.md updated with evidence before the session ends.
5. Second review by Codex requested on every non-trivial PR.

If unsure whether something is allowed: it isn't. Ask the user first.
