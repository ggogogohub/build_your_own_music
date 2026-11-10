# Gate 1 — Device Test Script

Run this on your iPhone after sideloading the `butter-dev.ipa` from the
`butter-dev-ipa` artifact (once CI run finishes green). The app opens to a
"engine probe" screen with 6 test tones loaded.

**How to verify:** each clip is a different musical pitch (330 → 880 Hz,
ascending). When the pitch steps up, the track changed. Total: 6 × 30 s.

## 1. Transport (play, pause, seek, skip) ✅/❌

- [ ] Tap play — tone 1 (330 Hz) starts.
- [ ] Tap pause — silence. Tap play — tone resumes.
- [ ] Drag the slider — position jumps, playback continues from there.
- [ ] Tap next-skip — pitch steps up (330 → 440 Hz).
- [ ] Tap prev-skip — pitch steps back down.

## 2. Gapless between tracks ✅/❌

- [ ] Let tone 1 play to the end (30 s) — tone 2 starts without a gap or a
      stutter. (The pitch changes 330 → 440 Hz.)

## 3. Lock screen + Control Center ✅/❌

- [ ] With playback running, lock the phone. **Audio keeps playing.**
- [ ] Lock screen shows a player widget with: title ("Test Tone 1 — 330 Hz"),
      artist ("BUTTER"), album ("Gate 1 Test Clips"), and the scrubber.
- [ ] Lock screen controls work: play/pause, next, prev.
- [ ] Swipe for Control Center: same controls work.
- [ ] **10-minute locked playback test:** start playback, lock the phone,
      wait 10 minutes. Audio still playing when you unlock.

## 4. Interruption handling ✅/❌

- [ ] Start playback, then call the phone from another number. Audio pauses.
- [ ] End the call. Audio **resumes automatically** (within a few seconds).

## 5. Battery drain ✅/❌

- [ ] Note battery % before the 10-min locked test. Note again after.
      Anything under ~1% for 10 min of playback is on track for the < 5%/hr
      gate (full-hour battery test can be done at Gate 2).

## 6. Result

Write your verdict in STATE.md (or reply "all passed" / list failures) and I'll
update the Gate 1 checklist. Then reply "GATE 1 APPROVED" only when items 1–5
are all ✅ — that unlocks Gate 2 (library & import: file_picker + Wi-Fi
transfer + metadata reader).
