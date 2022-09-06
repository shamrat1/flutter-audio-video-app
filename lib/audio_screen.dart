import 'package:audio_test/audio_common.dart';
import 'package:audio_test/audio_state.dart';
import 'package:audio_test/single_audio_screen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

class AudioScreen extends StatefulWidget {
  AudioScreen({Key? key, required this.percentage}) : super(key: key);
  double percentage;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioState>(builder: (context, state, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.percentage == 0)
            StreamBuilder<PositionData>(
              stream: state.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 2,
                  thumbRadius: 0,
                  thumbGlowRadius: 0,
                  thumbColor: Colors.transparent,
                  thumbCanPaintOutsideBar: false,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  progress: positionData?.position ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: state.player.seek,
                  timeLabelLocation: widget.percentage > 99
                      ? TimeLabelLocation.below
                      : TimeLabelLocation.none,
                );
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                height:
                    widget.percentage > 0 ? 50 * (widget.percentage + 1) : 50,
                duration: Duration(milliseconds: 200),
                child: Image.network(
                  state.audio?.img ?? "https://www.fillmurray.com/640/360",
                ),
              ),
              if (widget.percentage < 1) Spacer(),
              // if (percentage < 1)
              Opacity(
                opacity: widget.percentage == 1 ? 0 : 1,
                child: ControlButtons(state.player),
              ),
              // if (percentage == 0) ControlButtons(state.player),
              if (widget.percentage == 0)
                IconButton(
                  onPressed: () => state.close(),
                  icon: Icon(Icons.close),
                ),
            ],
          ),
          if (widget.percentage == 1)
            StreamBuilder<PositionData>(
              stream: state.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProgressBar(
                    thumbCanPaintOutsideBar: false,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    progress: positionData?.position ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: state.player.seek,
                    timeLabelLocation: widget.percentage > 99
                        ? TimeLabelLocation.below
                        : TimeLabelLocation.none,
                  ),
                );
              },
            ),
          if (widget.percentage == 1) ControlButtons(state.player),
        ],
      );
    });
  }
}
