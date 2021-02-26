import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'joystick/JoyStick.dart';

const String stay = 'd+000+000';
const duration = const Duration(milliseconds: 100);

class Remote extends StatefulWidget {
  final BluetoothDevice server;

  const Remote({this.server});

  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<Remote> {
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  String cmd;
  Timer timer;

  @override
  void initState() {
    if (timer?.isActive == true) {
      timer.cancel();
    }
    timer = Timer.periodic(duration, (Timer time) => _sendMessage(cmd ?? stay));
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    if (timer?.isActive == true) {
      timer.cancel();
    }
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (isConnecting
            ? Text('Connecting to ' + widget.server.name + '...')
            : isConnected
                ? Text('Live chat with ' + widget.server.name)
                : Text('Chat log with ' + widget.server.name)),
      ),
      body: Center(
        child: JoyStick(
          insideRadius: 50,
          outsideRadius: 100,
          callBack: isConnected
              ? (cmd) {}
              : (cmd) {
                  // _sendMessage(cmd);
                },
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    try {
      connection.output.add(utf8.encode(text + "\r\n"));
      await connection.output.allSent;
    } catch (e) {}
  }
}
