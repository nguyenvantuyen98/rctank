import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'BackgroundPainter.dart';
import 'position.dart';

class JoyStick extends StatefulWidget {
  JoyStick({
    @required this.insideRadius,
    @required this.outsideRadius,
    this.callBack,
  });

  final double insideRadius;
  final double outsideRadius;
  final Function(String cmd) callBack;

  @override
  _JoyStickState createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  StreamController<Position> controller = StreamController<Position>();
  //Radius of smallest circle
  double insideRadius;
  //Radius of medium circle
  double middleRadius;
  //Radius of largest circle
  double outsideRadius;
  //Pad from center Axis to largest Axis
  double padOut;
  //Horizontal position of stick
  double wPosition = 0.0;
  //Vertical position of stick
  double hPosition = 0.0;

  Size stickSize;

  @override
  void initState() {
    insideRadius = widget.insideRadius;
    middleRadius = widget.outsideRadius;
    outsideRadius = insideRadius + 1.1 * middleRadius;
    padOut = outsideRadius - insideRadius;
    Position.padLength = middleRadius;
    stickSize = Size(insideRadius, insideRadius);
    controller.sink.add(Position.center());
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(2 * outsideRadius, 2 * outsideRadius),
          painter: BackGroundPainter(
            smallRadius: insideRadius,
            largeRadius: middleRadius,
          ),
        ),
        //Stick layer
        StreamBuilder<Object>(
          stream: controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              setPosition(snapshot.data);
            }
            return Positioned(
              top: hPosition,
              left: wPosition,
              child: Container(
                width: 2 * insideRadius,
                height: 2 * insideRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(),
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
        //Listen layer
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onPanStart: (DragStartDetails dragStartDetails) {
                controller.sink.add(Position(dragStartDetails.localPosition));
              },
              onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                controller.sink.add(Position(dragUpdateDetails.localPosition));
              },
              onPanEnd: (DragEndDetails dragEndDetails) {
                controller.sink.add(Position.center());
              },
              child: Container(
                width: 2 * middleRadius,
                height: 2 * middleRadius,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setPosition(Position position) {
    if (position.distance > middleRadius) {
      double arctan = atan(position.localY / position.localX);
      hPosition = (middleRadius * sin(arctan)).abs();
      if (position.localY < 0) hPosition = -hPosition;
      wPosition = (middleRadius * cos(arctan)).abs();
      if (position.localX < 0) wPosition = -wPosition;
    } else {
      wPosition = position.localX;
      hPosition = position.localY;
    }
    wPosition = wPosition + padOut;
    hPosition = hPosition + padOut;

    widget.callBack(
      convertCmd(
        wPosition / middleRadius - 1.1,
        hPosition / middleRadius - 1.1,
      ),
    );
  }
}

String convertCmd(double wPosition, double hPosition) {
  print('$wPosition $hPosition');

  return 'd-023+031';
}
