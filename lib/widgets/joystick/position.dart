import 'dart:math';
import 'package:flutter/material.dart';

class Position {
  double localX;
  double localY;
  double distance;
  Position(Offset offset) {
    localX = offset.dx - padLength;
    localY = offset.dy - padLength;
    distance = sqrt(localX * localX + localY * localY);
  }

  Position.center() {
    localX = 0;
    localY = 0;
    distance = 0;
  }

  String toString() {
    return 'localX: $localX, localY: $localY';
  }

  static double padLength = 0.0;
}
