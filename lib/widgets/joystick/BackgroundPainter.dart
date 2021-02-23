import 'package:flutter/material.dart';

class BackGroundPainter extends CustomPainter {
  BackGroundPainter({
    @required this.smallRadius,
    @required this.largeRadius,
  });
  final double largeRadius;
  final double smallRadius;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, smallRadius, paint);
    canvas.drawCircle(center, largeRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
