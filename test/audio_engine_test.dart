import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:butter/core/audio/audio_engine.dart';
import 'package:butter/core/audio/track.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Track', () {
    test('toAudioSource() maps to file URI with MediaItem tag', () {
      final track = Track(
        id: 't1',
        path: '/tmp/song.mp3',
        title: 'Song',
        artist: 'Artist',
        album: 'Album',
        duration: const Duration(seconds: 180),
        artworkPath: '/tmp/art.png',
      );
      final source = track.toAudioSource() as UriAudioSource;
      expect(source.uri, Uri.file('/tmp/song.mp3'));
      final tag = source.tag as MediaItem;
      expect(tag.id, 't1');
      expect(tag.title, 'Song');
      expect(tag.album, 'Album');
      expect(tag.artist, 'Artist');
      expect(tag.duration, const Duration(seconds: 180));
      expect(tag.artUri, Uri.file('/tmp/art.png'));
    });

    test('toAudioSource() with no artwork keeps artUri null', () {
      final track = Track(
        id: 't2',
        path: '/tmp/song.flac',
        title: 'Song',
        artist: 'Artist',
      );
      final source = track.toAudioSource() as UriAudioSource;
      expect(source.uri, Uri.file('/tmp/song.flac'));
      expect((source.tag as MediaItem).artUri, isNull);
    });
  });

  group('AudioEngine', () {
    test('is a singleton per CLAUDE.md §3', () {
      expect(identical(AudioEngine.instance, AudioEngine.instance), isTrue);
    });
  });
}
