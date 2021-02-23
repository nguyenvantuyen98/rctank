import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'BackgroundPainter.dart';
import 'position.dart';

class JoyStick extends StatefulWidget {
  final double insideRadius;
  final double outsideRadius;
  JoyStick({@required this.insideRadius, @required this.outsideRadius});
  @override
  _JoyStickState createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  StreamController<Position> controller = StreamController<Position>();
  //Radius of smallest circle
  double sR;
  //Radius of medium circle
  double mR;
  //Radius of largest circle
  double lR;
  //Pad from center Axis to largest Axis
  double padOut;
  //Horizontal position of stick
  double wPosition = 0.0;
  //Vertical position of stick
  double hPosition = 0.0;

  Size stickSize;

  @override
  void initState() {
    sR = widget.insideRadius;
    mR = widget.outsideRadius;
    lR = sR + 1.1 * mR;
    padOut = lR - sR;
    Position.padLength = mR;
    stickSize = Size(sR, sR);
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
          size: Size(2 * lR, 2 * lR),
          painter: BackGroundPainter(
            smallRadius: sR,
            largeRadius: mR,
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
                width: 2 * sR,
                height: 2 * sR,
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
                width: 2 * mR,
                height: 2 * mR,
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
    if (position.distance > mR) {
      double arctan = atan(position.localY / position.localX);
      hPosition = (mR * sin(arctan)).abs();
      if (position.localY < 0) hPosition = -hPosition;
      wPosition = (mR * cos(arctan)).abs();
      if (position.localX < 0) wPosition = -wPosition;
    } else {
      wPosition = position.localX;
      hPosition = position.localY;
    }
    print('${wPosition / mR} ${hPosition / mR}');
    wPosition = wPosition + padOut;
    hPosition = hPosition + padOut;
  }
}
