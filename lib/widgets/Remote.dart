import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'joystick/JoyStick.dart';

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

  @override
  void initState() {
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
                  _sendMessage(cmd);
                },
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {}
    }
  }
}
