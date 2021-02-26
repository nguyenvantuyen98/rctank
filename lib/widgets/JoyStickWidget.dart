import 'dart:async';

import 'package:flutter/material.dart';

import 'joystick/JoyStick.dart';

const String stay = 'd+000+000';
const duration = const Duration(milliseconds: 100);

class JoyStickWidget extends StatefulWidget {
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<JoyStickWidget> {
  String cmd;
  Timer timer;
  @override
  void initState() {
    if (timer?.isActive == true) {
      timer.cancel();
    }
    timer = Timer.periodic(duration, (Timer time) => print(cmd ?? stay));
    super.initState();
  }

  @override
  void dispose() {
    if (timer?.isActive == true) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: JoyStick(
          insideRadius: 50,
          outsideRadius: 100,
          callBack: (cmd) {
            this.cmd = cmd;
          },
        ),
      ),
    );
  }
}
