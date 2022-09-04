import 'package:audio_test/screen_two_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ScreenTwoOne())),
                  child: Text("Go to Two one"))
            ],
          ),
        ),
      ),
    );
  }
}
