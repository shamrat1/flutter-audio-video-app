import 'package:audio_test/screen_three.dart';
import 'package:audio_test/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _audioUrls = [
    "https://download.samplelib.com/mp3/sample-15s.mp3",
    "https://download.samplelib.com/mp3/sample-15s.mp3",
    "https://download.samplelib.com/mp3/sample-15s.mp3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => HomePage()));
              break;
            case 1:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ScreenTwo()));
              break;
            case 2:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ScreenThree()));
              break;
            default:
          }
        },
      ),
      body: ListView.builder(
        itemCount: _audioUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Audio $index"),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (ctx) =>
              //         SingleAudioScreen(audioUrl: _audioUrls[index])));
              // showOverlay(
              //     context: context,
              //     builder: (context, animation, s) {
              //       return SingleAudioScreen(audioUrl: _audioUrls[index]);
              //     });
              // Overlayment.show(OverWindow(
              //     name: "audio",
              //     // position: state.offset,
              //     // actions: OverlayActions(),
              //     alignment: Alignment.bottomCenter,
              //     child: Miniplayer(
              //       maxHeight: 500,
              //       minHeight: 50,
              //       controller: MiniplayerController(),
              //       builder: (height, percentage) {
              //         return Text("$height | $percentage");
              //       },
              //     )));
            },
          );
        },
      ),
    );
  }
}
