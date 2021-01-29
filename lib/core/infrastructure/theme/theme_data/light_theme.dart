import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

class LightTheme {
  static ThemeData getThemeData(Color color) {
    return ThemeData(
      primarySwatch: color,
      accentColor: color,
      brightness: Brightness.light,
      fontFamily: 'Manrope',
      //canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 1,
        color: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: CardTheme(elevation: 0.5),
      primaryIconTheme: IconThemeData(color: Colors.grey[900], opacity: 0.50),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.grey[900],
        ),
        headline5: heaingSmall.copyWith(color: Colors.grey[900]),
        bodyText2: bodyStyle1.copyWith(color: Colors.grey[900]),
      ),
      cursorColor: color,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionHandleColor: color,
    );
  }
}

final cupertino = CupertinoThemeData(
  brightness: Brightness.light,
);
