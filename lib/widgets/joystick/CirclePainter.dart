import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({
    @required this.circleOffset,
    @required this.radius,
  });

  final Offset circleOffset;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(circleOffset, radius, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}