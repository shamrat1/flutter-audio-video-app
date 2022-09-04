import 'package:audio_test/audio_common.dart';
import 'package:audio_test/main.dart';
import 'package:audio_test/offset_state.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:overlayment/overlayment.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

class SingleAudioScreen extends StatefulWidget {
  SingleAudioScreen({Key? key, required this.audioUrl}) : super(key: key);
  final String audioUrl;

  @override
  State<SingleAudioScreen> createState() => _SingleAudioScreenState();
}

class _SingleAudioScreenState extends State<SingleAudioScreen> {
  final player = AudioPlayer();
  double _height = 0;
  bool _isExpanded = true;
  Offset _offset = Offset(0, 0);
  @override
  void initState() {
    super.initState();
    // player.setUrl(widget.audioUrl);
    // player.play();
    _init();
  }

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
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.audioUrl),
            tag: MediaItem(id: widget.audioUrl, title: "Audio File")),
      );
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      _height = MediaQuery.of(context).size.height * 0.99;
    }
    return Consumer<OffsetState>(builder: (context, state, _) {
      return AnimatedPositioned(
        duration: Duration(microseconds: 100),
        left: state.offset.dx,
        top: state.offset.dy,
        child: Container(
          color: _isExpanded ? Colors.blue : Colors.amber,
          height: _height,
          width: MediaQuery.of(context).size.width - 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isExpanded)
                IconButton(
                    onPressed: () {
                      print(MediaQuery.of(context).size.height * 0.90);
                      setState(() {
                        _isExpanded = false;
                        _height = MediaQuery.of(context).size.height * 0.10;
                        // audioOffset =
                        //     Offset(0, MediaQuery.of(context).size.height * 0.90);
                        context.read<OffsetState>().update(Offset(
                            0, -MediaQuery.of(context).size.height * 0.90));
                      });
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                    )),
              // Display play/pause button and volume/speed sliders.
              if (_isExpanded) ControlButtons(player),
              // Display seek bar. Using StreamBuilder, this widget rebuilds
              // each time the position, buffered position or duration changes.
              if (!_isExpanded)
                Row(
                  children: [
                    Text("Audio file"),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = true;
                            _height = MediaQuery.of(context).size.height * 0.99;
                            // audioOffset =
                            //     Offset(0, MediaQuery.of(context).size.height * 0.90);
                            context.read<OffsetState>().update(Offset(0, 0));
                          });
                        },
                        child: Text("Expand")),
                    IconButton(
                        onPressed: () {
                          Overlayment.dismissAll();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
              if (_isExpanded)
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                    );
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
