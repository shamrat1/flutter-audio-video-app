import 'package:audio_test/audio_state.dart';
import 'package:audio_test/screen_three.dart';
import 'package:audio_test/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AudioObject {
  final String title, subtitle, img, url;

  const AudioObject(this.title, this.subtitle, this.img, this.url);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AudioObject> _audioUrls = [
    AudioObject(
        'Salt & Pepper',
        'Dope Lemon',
        'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject('Losing It', 'FISHER', 'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject(
        'American Kids',
        'Kenny Chesney',
        'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject('Wake Me Up', 'Avicii', 'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject('Missing You', 'Mesto', 'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject('Drop it dirty', 'Tavengo', 'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject('Cigarettes', 'Tash Sultana', 'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
    AudioObject(
        'Ego Death',
        'Ty Dolla \$ign, Kanye West, FKA Twigs, Skrillex',
        'https://placekitten.com/640/360',
        "https://download.samplelib.com/mp3/sample-15s.mp3"),
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
            title: Text(_audioUrls[index].title),
            onTap: () {
              context.read<AudioState>().setUrl(_audioUrls[index]);
              context.read<AudioState>().setPanelToMax();
            },
          );
        },
      ),
    );
  }
}
