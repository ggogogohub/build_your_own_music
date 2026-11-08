# BUTTER

A free-forever, offline-first iOS music player built from real Reddit and App Store complaints.

- **No ads. No accounts. No tracking.** Works fully offline with your own files.
- **Lossless support**: MP3, FLAC, ALAC, WAV.
- **Wi-Fi transfer**: drag music from your PC browser to your phone over LAN.
- **Buttery UI**: 120fps ProMotion-capable, token-driven design.

## Status

🚧 In development — Gate 0 (bootstrap & pipeline).

## Development

- Flutter (Dart) on Windows; all iOS builds run in GitHub Actions.
- `ios-dev.yml` builds an unsigned IPA per push to main; sideload with Sideloadly.
- `ios-testflight.yml` stays dormant until Gate 5.

## License

MIT — see [LICENSE](LICENSE).
