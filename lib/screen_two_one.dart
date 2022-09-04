import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenTwoOne extends StatefulWidget {
  const ScreenTwoOne({Key? key}) : super(key: key);

  @override
  State<ScreenTwoOne> createState() => _ScreenTwoOneState();
}

class _ScreenTwoOneState extends State<ScreenTwoOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[500],
      body: Container(
        child: Center(child: Text("Screen two One")),
      ),
    );
  }
}
