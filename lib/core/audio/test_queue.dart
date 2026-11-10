import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'track.dart';

/// Gate 1 test fixture: the 6 bundled test tones, exposed as a playable queue.
///
/// Gate 2's real library index (drift/isar) will replace this; the engine
/// consumes [Track]s only. The bundled clips are 30s AAC sine tones
/// (330–880 Hz) — see assets/audio/test/README.md.
class TestQueue {
  TestQueue._();

  /// The 6 bundled test clips, resolved to local files.
  static Future<List<Track>> load() async {
    const names = [
      'clip_1_tone_330hz',
      'clip_2_tone_440hz',
      'clip_3_tone_550hz',
      'clip_4_tone_660hz',
      'clip_5_tone_770hz',
      'clip_6_tone_880hz',
    ];
    const hz = [330, 440, 550, 660, 770, 880];
    final tracks = <Track>[];
    for (var i = 0; i < names.length; i++) {
      final path = await _resolveAssetPath('assets/audio/test/${names[i]}.m4a');
      tracks.add(Track(
        id: 'test-${i + 1}',
        path: path,
        title: 'Test Tone ${i + 1} — ${hz[i]} Hz',
        artist: 'BUTTER',
        album: 'Gate 1 Test Clips',
        duration: const Duration(seconds: 30),
      ));
    }
    return tracks;
  }

  /// Resolves a bundled asset to an absolute file path so the engine can
  /// play it as a local file.
  static Future<String> _resolveAssetPath(String assetKey) async {
    final byteData = await rootBundle.load(assetKey);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/butter-test-assets/${assetKey.split('/').last}');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }
}
