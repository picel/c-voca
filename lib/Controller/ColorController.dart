import 'package:flutter/material.dart';

class ColorController {
  static Color textColorDecision(Color color) {
    if (color.computeLuminance() > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  static Color oppsiteColor(Color color) {
    var r = 255 - color.red;
    var g = 255 - color.green;
    var b = 255 - color.blue;
    return Color.fromARGB(255, r, g, b);
  }
}
