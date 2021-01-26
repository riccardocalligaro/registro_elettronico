import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

class BlackTheme {
  static ThemeData getThemeData(MaterialColor color) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: color,
      buttonColor: color,
      // primaryColor: color,
      accentColor: color,
      dialogBackgroundColor: Color(0xff0f0f0f),
      // primaryColor: color,
      brightness: Brightness.dark,
      canvasColor: Colors.black,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.black,
        brightness: Brightness.dark,
      ),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
        headline5: heaingSmall.copyWith(color: Colors.white),
        bodyText2: bodyStyle1.copyWith(color: Colors.white),
      ),
      cardTheme: CardTheme(color: Color(0xff0f0f0f)),
      cursorColor: color,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionHandleColor: color,
    );
  }
}
