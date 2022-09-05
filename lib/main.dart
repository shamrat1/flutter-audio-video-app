import 'package:audio_test/audio_common.dart';
import 'package:audio_test/audio_state.dart';
import 'package:audio_test/home.dart';
import 'package:audio_test/offset_state.dart';
import 'package:audio_test/screen_three.dart';
import 'package:audio_test/screen_two.dart';
import 'package:audio_test/single_audio_screen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:overlayment/overlayment.dart';
import 'package:provider/provider.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => OffsetState()),
    ChangeNotifierProvider(create: (ctx) => AudioState()),
  ], child: const MyApp()));
}

final _navigatorKey = GlobalKey<NavigatorState>();
const double playerMinHeight = 70;
const double playerMaxHeight = 600;
const miniplayerPercentageDeclaration = 0.2;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Overlayment.navigationKey = _navigatorKey;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(playerMinHeight);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = _navigatorKey.currentState!;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Consumer<AudioState>(builder: (context, state, _) {
          return Stack(
            children: [
              Navigator(
                key: _navigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (BuildContext context) => HomePage(),
                ),
              ),
              if (state.audio != null)
                Positioned(
                  bottom: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: Miniplayer(
                    maxHeight: playerMaxHeight,
                    minHeight: playerMinHeight,
                    valueNotifier: playerExpandProgress,
                    controller: state.controller,
                    onDismiss: () {
                      state.player.stop();
                    },
                    builder: (height, percentage) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (percentage == 0)
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
                                  buffered: positionData?.bufferedPosition ??
                                      Duration.zero,
                                  progress:
                                      positionData?.position ?? Duration.zero,
                                  total:
                                      positionData?.duration ?? Duration.zero,
                                  onSeek: state.player.seek,
                                  timeLabelLocation: percentage > 99
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
                                    percentage > 0 ? 50 * (percentage + 1) : 50,
                                duration: Duration(milliseconds: 200),
                                child: Image.network(
                                  state.audio?.img ??
                                      "https://www.fillmurray.com/640/360",
                                ),
                              ),
                              if (percentage < 1) Spacer(),
                              // if (percentage < 1)
                              Opacity(
                                opacity: percentage == 1 ? 0 : 1,
                                child: ControlButtons(state.player),
                              ),
                              // if (percentage == 0) ControlButtons(state.player),
                              if (percentage == 0)
                                IconButton(
                                  onPressed: () => state.controller
                                      .animateToHeight(
                                          state: PanelState.DISMISS),
                                  icon: Icon(Icons.close),
                                ),
                            ],
                          ),
                          if (percentage == 1)
                            StreamBuilder<PositionData>(
                              stream: state.positionDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ProgressBar(
                                    thumbCanPaintOutsideBar: false,
                                    buffered: positionData?.bufferedPosition ??
                                        Duration.zero,
                                    progress:
                                        positionData?.position ?? Duration.zero,
                                    total:
                                        positionData?.duration ?? Duration.zero,
                                    onSeek: state.player.seek,
                                    timeLabelLocation: percentage > 99
                                        ? TimeLabelLocation.below
                                        : TimeLabelLocation.none,
                                  ),
                                );
                              },
                            ),
                          if (percentage == 1) ControlButtons(state.player),
                        ],
                      );
                    },
                  ),
                )
            ],
          );
        }),
      ),
    );
  }

  void onTap() {}

  double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }
}
