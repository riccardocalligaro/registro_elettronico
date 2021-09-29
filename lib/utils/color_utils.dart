import 'dart:math';

import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ColorUtils {
  /// Returns a color by checking the event [code]
  ///
  /// [Red] for Absence, [Blue] for delay and [yellow] for early exit
  static Color? getColorFromCode(String? code) {
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

  static Color? getLessonCardColor(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.secondary;

    if (themeColor == Colors.red || themeColor.value == 4294198070) {
      return Colors.red[400];
    }

    return themeColor;
  }

  static List<Color?> getCardsColors(int length) {
    List<Color?> _colors = [
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    if (length > _colors.length) {
      int remaining = length - _colors.length;
      for (var i = 0; i < remaining; i++) {
        _colors.add(getRandomMaterialColor());
      }
    }
    _colors.shuffle();
    return _colors;
  }

  static Color? getDropHeaderColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else if (Theme.of(context).scaffoldBackgroundColor == Colors.black) {
      return Colors.black;
    }
    return Colors.grey[900];
  }

  static List<Color?> getGradientForColor(
    Color color, {
    bool button = false,
  }) {
    if (color == Colors.yellow) {
      return [Colors.yellow[700], Colors.yellow[900]];
    } else if (color == Colors.green) {
      return [Colors.green[500], Colors.green[800]];
    } else if (color == Colors.red || color.value == 4294198070) {
      if (button) {
        return [
          Colors.red[600],
          Colors.red[800],
        ];
      }
      return [Colors.red[400], Colors.red[800]];
    }

    return [
      TinyColor(color).color,
      TinyColor(color).darken(20).color,
    ];
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};

    final int r = color.red, g = color.green, b = color.blue;
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    // TODO: fix this
    return MaterialColor(color.value, swatch);
  }

  static String getColorNameFromColor(
    MaterialColor color,
    BuildContext context,
  ) {
    if (color == Colors.yellow) {
      return 'Yellow';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else if (color == Colors.green) {
      return 'Green';
    } else {
      return 'Red';
    }
  }
  // static MaterialColor getColorFromConstant(String value) {
  //   MaterialColor();
  //   if (value == ColorConstants.blue) {
  //     return Colors.blue;
  //   } else if (value == ColorConstants.green) {
  //     return Colors.green;
  //   } else if (value == ColorConstants.yellow) {
  //     return Colors.yellow;
  //   }

  //   return Colors.red;
  // }

  // static MaterialColor getConstantFromColor(String value) {
  //   if (value == ColorConstants.blue) {
  //     return Colors.blue;
  //   } else if (value == ColorConstants.green) {
  //     return Colors.green;
  //   } else if (value == ColorConstants.yellow) {
  //     return Colors.yellow;
  //   }

  //   return Colors.red;
  // }

  static Color? getRandomMaterialColor() {
    Random random = Random();
    int randomNumber = random.nextInt(5);
    return getColorFromIndex(randomNumber);
  }

  static Color? getColorFromIndex(int index) {
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
      case 1:
        return Colors.pink;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.deepPurple;
      case 4:
        return Colors.indigo;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.green;
      case 7:
        return Colors.greenAccent;
      case 8:
        return Colors.amber;
      case 9:
        return Colors.orange;
      case 10:
        return Colors.blue[900];
      case 11:
        return Colors.lightGreen;
      case 12:
        return Colors.lightBlue;
      case 13:
        return Colors.yellow[700];
      case 14:
        return Colors.teal;
      case 15:
        return Colors.tealAccent;
      case 16:
        return Colors.redAccent;
      default:
        return Colors.red;
    }
  }
}
