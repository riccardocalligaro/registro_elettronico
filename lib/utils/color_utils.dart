import 'dart:math';

import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

class ColorUtils {
  /// Returns a color by checking the event [code]
  ///
  /// [Red] for Absence, [Blue] for delay and [yellow] for early exit
  static Color getColorFromCode(String code) {
    if (code == RegistroConstants.ASSENZA) {
      return Colors.red;
    } else if (code == RegistroConstants.RITARDO) {
      return Colors.blue;
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return Colors.blue;
    } else if (code == RegistroConstants.USCITA) {
      return Colors.yellow[700];
    } else {
      return Colors.blue;
    }
  }

  static Color getRandomMaterialColor() {
    Random random = Random();
    int randomNumber = random.nextInt(5);
    return getColorFromIndex(randomNumber);
  }

  static Color getColorFromIndex(int index) {
    if (index > 16) {
      try {
        Random random = Random();
        int indexMaterial = random.nextInt(Colors.accents.length - 1);
        return Colors.accents[indexMaterial];
      } catch (_) {
        return Colors.red;
      }
    }

    switch (index) {
      case 0:
        return Colors.red;
        break;
      case 1:
        return Colors.pink;
        break;
      case 2:
        return Colors.purple;
        break;
      case 3:
        return Colors.deepPurple;
        break;
      case 4:
        return Colors.indigo;
        break;
      case 5:
        return Colors.blue;
        break;
      case 6:
        return Colors.green;
        break;
      case 7:
        return Colors.greenAccent;
        break;
      case 8:
        return Colors.amber;
        break;
      case 9:
        return Colors.orange;
        break;
      case 10:
        return Colors.blue[900];
        break;
      case 11:
        return Colors.lightGreen;
      case 12:
        return Colors.lightBlue;
      case 13:
        return Colors.yellow[700];
        break;
      case 14:
        return Colors.teal;
        break;
      case 15:
        return Colors.tealAccent;
        break;
      case 16:
        return Colors.redAccent;
        break;
      default:
        return Colors.red;
    }
  }
}
