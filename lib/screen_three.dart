import 'package:audio_test/screen_three_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenThree extends StatefulWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ScreenThreeOne())),
                  child: Text("Go to Threen one"))
            ],
          ),
        ),
      ),
    );
  }
}
