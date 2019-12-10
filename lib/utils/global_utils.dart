import 'dart:math';
import 'package:flutter/material.dart';

class GlobalUtils {
  static String reduceSubjectTitle(String name) {
    //TODO: try to reduce name by creating a switch with abbreviations
    String reducedName = name.substring(0, 20);
    reducedName += "...";
    return reducedName;
  }

  static String reduceLessonArgument(String argument) {
    String reducedName = argument.substring(0, 30);
    reducedName += "...";
    return reducedName;
  }

  static Color generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  static Color getColorFromPosition(int position) {
    // TODO: generate more colors, 10 - 15
    // TODO: need to set a subject color in the database
    switch (position) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.indigo;
        break;
      case 3:
        return Colors.green;
        break;
      case 4:
        return Colors.amber;
        break;
      case 5:
        return Colors.deepOrange;
        break;
      case 6:
        return Colors.indigo;
        break;
      default:
        return Colors.red;
    }
  }
}
