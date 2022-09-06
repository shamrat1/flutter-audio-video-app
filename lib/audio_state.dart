import 'package:audio_test/audio_common.dart';
import 'package:audio_test/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

class AudioState extends ChangeNotifier {
  AudioObject? audio;
  String url = "";
  final player = AudioPlayer();

  MiniplayerController controller = MiniplayerController();

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      print(audio?.url);
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await player.setAudioSource(
        AudioSource.uri(Uri.parse(audio!.url),
            tag: MediaItem(
                id: audio!.url, title: audio!.title, album: audio!.subtitle)),
      );
      player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  setUrl(AudioObject audioObject) {
    audio = audioObject;
    _init();

    notifyListeners();
  }

  setPanelToMax() {
    controller.animateToHeight(state: PanelState.MAX);
    notifyListeners();
  }

  close() {
    audio = null;
    player.stop();
    // positionDataStream
    notifyListeners();
  }

  setPanelToMin() {
    controller.animateToHeight(state: PanelState.MIN);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
