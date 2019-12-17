import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/themes/theme_data/text_styles.dart';

final mainTextTheme = TextTheme(headline: HeadingSmall, body1: BodyStyle1);

final defaultTheme = ThemeData(
  brightness: Brightness.light,
  accentColor: Colors.red,
  primaryColor: Colors.red,
  textTheme: mainTextTheme,
  fontFamily: 'Montserrat',
  primaryIconTheme: IconThemeData(color: Colors.black),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
  }),
);
