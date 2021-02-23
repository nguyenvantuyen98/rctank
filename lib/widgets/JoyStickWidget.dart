import 'package:flutter/material.dart';

import 'joystick/JoyStick.dart';
class JoyStickWidget extends StatefulWidget {
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<JoyStickWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: JoyStick(
          insideRadius: 50,
          outsideRadius: 100,
        ),
      ),
    );
  }
}
