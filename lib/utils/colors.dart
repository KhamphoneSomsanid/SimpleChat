import 'dart:math';

import 'package:flutter/material.dart';

const Color primaryColor = Colors.green;
const Color blueColor = Color(0xFF439FDF);
const Color blackColor = Color(0xFF383838);
const Color shadowColor = Color(0x38000000);

Color getRandomColor() {
  var colors = [
    Colors.deepOrange,
    Colors.yellow,
    Colors.green,
    Colors.lightGreen,
    Colors.grey,
    Colors.orangeAccent,
    Colors.orange,
    Colors.blue,
    Colors.cyanAccent,
    Colors.deepPurple
  ];
  return colors[Random().nextInt(10)];
}

LinearGradient getGradientColor({Color color = primaryColor}) {
  return LinearGradient(
      colors: [
        color.withOpacity(0.75),
        color.withOpacity(0.25),
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);
}
