/// A single playable track — BUTTER's queue model.
///
/// Gate 2's library index (drift/isar) will produce these; the engine only
/// consumes them.
class Track {
  const Track({
    required this.id,
    required this.path,
    required this.title,
    required this.artist,
    this.album,
    this.duration,
    this.artworkPath,
  });

  /// Stable id, used for lock-screen metadata and error reporting.
  final String id;

  /// Absolute path to the audio file.
  final String path;

  final String title;
  final String artist;
  final String? album;
  final Duration? duration;

  /// Absolute path to embedded artwork (null → fallback cover is shown).
  final String? artworkPath;
}
