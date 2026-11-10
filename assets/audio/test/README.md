# Gate 1 test clips

Six 30-second AAC sine tones (330–880 Hz), generated with ffmpeg for
device-verification of the audio engine (Gate 1). Each clip is one octave-step
apart so skip and gapless-transition tests are audible: when you hear the pitch
step up, the track changed.

**These are temporary test fixtures — removed at Gate 3** (Gate 2 brings real
imported files).

| File | Frequency | Size |
|---|---|---|
| clip_1_tone_330hz.m4a | 330 Hz | 486 KB |
| clip_2_tone_440hz.m4a | 440 Hz | 486 KB |
| clip_3_tone_550hz.m4a | 550 Hz | 486 KB |
| clip_4_tone_660hz.m4a | 660 Hz | 486 KB |
| clip_5_tone_770hz.m4a | 770 Hz | 486 KB |
| clip_6_tone_880hz.m4a | 880 Hz | 485 KB |

Generated with: `ffmpeg -f lavfi -i "sine=frequency=330:duration=30" -f lavfi -i "sine=frequency=660:duration=30" -filter_complex "[0][1]amix=inputs=2:duration=first,volume=0.5" -acodec aac -b:a 128k`
