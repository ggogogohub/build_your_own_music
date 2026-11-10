# STATE.md — Project BUTTER

**Current gate: 1 — Audio Engine**
**Updated: 2026-11-10 (session 3)**

## Pipeline status

- 🟢 **GREEN** — run `42725127129` ("feat(gate-1): audio engine — just_audio +
  just_audio_background") on `main` @ `bbc6f69` passed. First build with native
  plugins (just_audio Objective-C); `butter-dev-ipa` artifact exists.
- Repo: https://github.com/ggogogohub/build_your_own_music (public)

## Gate 1 checklist (audio engine)

| Item | Status |
|---|---|
| just_audio + audio_service integrated: play, pause, seek, skip | ✅ Code written — `AudioEngine` singleton (just_audio 0.10.6 + just_audio_background 0.0.1-beta.17, which wraps audio_service). play/pause/seek/skipToNext/skipToPrevious/skipTo/shuffle/repeat. Unit tests pass. |
| Background playback survives 10 min locked screen | ⏳ Awaiting device test (next build). `UIBackgroundModes: audio` added to Info.plist. |
| Lock screen + Control Center controls | ⏳ Awaiting device test. MediaItem tags (title/artist/album/artUri) wired in `Track.toAudioSource()`. |
| Interruption handling | ⏳ Awaiting device test. `handleInterruptions: true` (auto-pause on call, auto-resume after). |
| Battery drain < 5%/hr | ⏳ Awaiting device test. |
| Formats MP3/FLAC/ALAC/WAV | ⏳ Awaiting device test. Bundled clips are AAC so far; Gate 2 import will verify MP3/FLAC/ALAC/WAV. |
| Gapless between tracks | ⏳ Awaiting device test. `setAudioSources` playlist API. |

## Done this session

- Added just_audio ^0.10.6 + just_audio_background ^0.0.1-beta.17 + path_provider.
- `AudioEngine` singleton (`lib/core/audio/audio_engine.dart`): play/pause/seek/skip,
  shuffle/repeat, queue management, streams for UI. `maxSkipsOnError: 3`.
- `Track` model + `toAudioSource()` → file URI + MediaItem tag (lock-screen metadata).
- `TestQueue` fixture: 6 bundled 30s AAC sine tones (330–880 Hz) in `assets/audio/test/`,
  copied to a temp dir at load so the engine plays them as local files.
- `UIBackgroundModes: audio` added to `ios/Runner/Info.plist`.
- Engine probe screen in `lib/main.dart` (temporary harness — replaced by Gate 3 UI).
- Removed default widget_test.dart (referenced deleted MyApp counter).
- `flutter analyze` clean, `flutter test` 3/3 pass.
- Committed `bbc6f69` and pushed; CI run `42725127129` **GREEN** with `butter-dev-ipa`.
- Device test script written: `docs/gate-1-device-test.md` (transport, gapless,
  lock screen/Control Center + 10-min locked playback, phone-call interruption,
  battery drain).

## Open issues / blockers

1. **Codex usage limits** — user logged in with a free ChatGPT account; Claude subagent
   stands in for second review until Gate 5 (sanctioned by the design doc).
2. **settings.json permissions merge** — user action, pending.
3. **Stray folder** — `C:\Users\mahakaal\Documents\build_your_music` (mistyped path,
   one file inside; user approved deletion but the classifier blocked it; harmless,
   can be deleted manually).

## Standing action items

1. **Q5 observation (office-hours finding):** watch 1 real person move music from
   their PC to their phone before Gate 2 ships.
2. **48-hour wedge probe** preserved as an optional accelerant if Gate 2 stalls
   (trigger: 2027-01-03 slip past 2026-12-20 baseline).

## Next queued task

1. **User:** sideload `butter-dev-ipa` from run `42725127129` via Sideloadly, run
   the device test script (`docs/gate-1-device-test.md`):
   - Play/pause/seek/skip with the 6 test tones (audible pitch steps).
   - Lock screen: controls visible, artwork shown, 10 min locked playback.
   - Control Center: remote commands work.
   - Phone call interruption: pauses, resumes after.
   - Battery: <5%/hr during playback.
2. **User:** reply "GATE 1 APPROVED" when all items pass → Gate 2 (library & import).
