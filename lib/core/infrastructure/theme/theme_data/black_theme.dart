import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

class BlackTheme {
  static ThemeData getThemeData(MaterialColor color) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      dialogBackgroundColor: Color(0xff0f0f0f),
      brightness: Brightness.dark,
      canvasColor: Colors.black,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
        headline5: heaingSmall.copyWith(color: Colors.white),
        bodyText2: bodyStyle1.copyWith(color: Colors.white),
      ),
      cardTheme: CardTheme(color: Color(0xff0f0f0f)),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: color,
        selectionHandleColor: color,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: color)
          .copyWith(secondary: color),
    );
  }
}
