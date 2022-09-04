import 'package:audio_test/home.dart';
import 'package:audio_test/offset_state.dart';
import 'package:audio_test/screen_three.dart';
import 'package:audio_test/screen_two.dart';
import 'package:audio_test/single_audio_screen.dart';
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
  ], child: const MyApp()));
}

final _navigatorKey = GlobalKey<NavigatorState>();

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
        body: Stack(
          children: [
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => HomePage(),
              ),
            ),
            Positioned(
              bottom: kToolbarHeight,
              left: 0,
              right: 0,
              child: Miniplayer(
                maxHeight: 500,
                minHeight: 50,
                controller: MiniplayerController(),
                builder: (height, percentage) {
                  return Text("$height | $percentage");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
