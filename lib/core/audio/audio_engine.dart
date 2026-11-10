import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'track.dart';

/// The single AudioPlayer instance for the whole app (CLAUDE.md §3: "single
/// AudioPlayer instance owned by an AudioHandler"; UI never talks to
/// just_audio directly — it talks to this class).
///
/// Gate 1 items covered:
/// - play/pause/seek/skip            play/pause/seek/skipToNext/skipToPrevious/skipTo
/// - lock screen + Control Center    MediaItem tags → MPNowPlayingInfoCenter
/// - background playback             UIBackgroundModes audio in Info.plist
/// - interruptions                   handleInterruptions: true — auto-pause on
///                                    phone call, auto-resume after
/// - gapless between tracks          playlist of IndexedAudioSources
/// - skip-on-error                   maxSkipsOnError: 3
class AudioEngine {
  AudioEngine._(this._player);

  static AudioEngine? _instance;

  /// Singleton — one AudioPlayer instance for the whole app.
  static AudioEngine get instance => _instance ??= AudioEngine._(AudioPlayer(
        handleInterruptions: true,
        handleAudioSessionActivation: true,
        useLazyPreparation: true,
        maxSkipsOnError: 3,
      ));

  final AudioPlayer _player;

  // ---- State exposure (streams) ----

  /// Whether audio is playing.
  Stream<bool> get playingStream => _player.playingStream;
  bool get playing => _player.playing;

  /// Current position in the current track.
  Stream<Duration> get positionStream => _player.createPositionStream(
        steps: 800,
        minPeriod: const Duration(milliseconds: 16),
        maxPeriod: const Duration(milliseconds: 16),
      );

  /// Buffered position in the current track (local files buffer quickly).
  Stream<Duration> get bufferedPositionStream =>
      _player.bufferedPositionStream;

  /// Total duration of the current track.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Index of the current track in the queue (null while no queue is loaded).
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  /// True when a track is loaded (queue set).
  Stream<bool> get processingStateStream =>
      _player.processingStateStream.map((s) => s != ProcessingState.idle);

  // ---- Queue management ----

  List<Track> _queue = const [];

  /// The queue currently loaded into the player.
  List<Track> get queue => _queue;

  /// Loads a queue of [tracks] and starts at [initialIndex].
  Future<void> loadQueue(List<Track> tracks, {int initialIndex = 0}) async {
    assert(tracks.isNotEmpty, 'loadQueue requires at least one track');
    _queue = List.unmodifiable(tracks);
    await _player.setAudioSources(
      tracks.map((t) => t.toAudioSource()).toList(),
      initialIndex: initialIndex,
      initialPosition: Duration.zero,
    );
  }

  // ---- Transport ----

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();

  Future<void> togglePlayPause() async {
    _player.playing ? await pause() : await play();
  }

  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> skipToNext() => _player.seekToNext();
  Future<void> skipToPrevious() => _player.seekToPrevious();
  Future<void> skipTo(int index) => _player.seek(Duration.zero, index: index);

  /// Toggles shuffle mode on/off.
  Future<void> toggleShuffle() async {
    await _player.setShuffleModeEnabled(!_player.shuffleModeEnabled);
  }

  /// Cycles repeat: off → all → one → off.
  Future<void> cycleRepeatMode() async {
    switch (_player.loopMode) {
      case LoopMode.off:
        await _player.setLoopMode(LoopMode.all);
      case LoopMode.all:
        await _player.setLoopMode(LoopMode.one);
      case LoopMode.one:
        await _player.setLoopMode(LoopMode.off);
    }
  }

  // ---- Teardown ----

  Future<void> dispose() async {
    await _player.dispose();
    _instance = null;
  }
}

/// Converts a [Track] to a just_audio source with a MediaItem tag (lock-screen
/// metadata requirement).
extension TrackToAudioSource on Track {
  AudioSource toAudioSource() {
    final artFile = artworkPath;
    return AudioSource.uri(
      Uri.file(path),
      tag: MediaItem(
        id: id,
        title: title,
        album: album,
        artist: artist,
        duration: duration,
        artUri: artFile != null ? Uri.file(artFile) : null,
      ),
    );
  }
}
