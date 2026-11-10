import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'core/audio/audio_engine.dart';
import 'core/audio/test_queue.dart';

Future<void> main() async {
  // Lock-screen/Control Center controls + background playback require
  // JustAudioBackground.init before runApp (just_audio_background README).
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.butterapp.butter.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const ButterApp());
}

/// Gate 1 test harness screen. Temporary — replaced by the Gate 3 UI.
class ButterApp extends StatelessWidget {
  const ButterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butter',
      home: const EngineProbeScreen(),
    );
  }
}

class EngineProbeScreen extends StatefulWidget {
  const EngineProbeScreen({super.key});

  @override
  State<EngineProbeScreen> createState() => _EngineProbeScreenState();
}

class _EngineProbeScreenState extends State<EngineProbeScreen> {
  final AudioEngine _engine = AudioEngine.instance;
  bool _queueLoaded = false;
  bool _loadError = false;
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration? _duration;
  int? _index;

  @override
  void initState() {
    super.initState();
    _loadQueue();
    _engine.playingStream.listen((p) {
      if (mounted) setState(() => _playing = p);
    });
    _engine.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _engine.durationStream.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _engine.currentIndexStream.listen((i) {
      if (mounted) setState(() => _index = i);
    });
    _engine.processingStateStream.listen((ready) {
      if (mounted) setState(() => _queueLoaded = ready);
    });
  }

  Future<void> _loadQueue() async {
    try {
      final tracks = await TestQueue.load();
      await _engine.loadQueue(tracks);
      if (mounted) setState(() => _loadError = false);
    } catch (e) {
      if (mounted) setState(() => _loadError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _engine.queue;
    final track = (_index != null && _index! < tracks.length) ? tracks[_index!] : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUTTER engine probe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(track?.title ?? 'No track'),
            Text(track?.artist ?? 'No artist'),
            Text(track?.album ?? 'No album'),
            Text('$_position / $_duration'),
            Text('index: $_index'),
            Text('queueLoaded: $_queueLoaded'),
            if (_loadError) const Text('Load failed — see console'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _engine.skipToPrevious,
                ),
                IconButton(
                  icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                  onPressed: _engine.togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _engine.skipToNext,
                ),
              ],
            ),
            Slider(
              value: _position.inMilliseconds.toDouble(),
              max: _duration?.inMilliseconds.toDouble() ?? 1.0,
              onChanged: (v) => _engine.seek(Duration(milliseconds: v.toInt())),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: _engine.toggleShuffle,
                ),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  onPressed: _engine.cycleRepeatMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
