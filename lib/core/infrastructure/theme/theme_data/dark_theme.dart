import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

final material = ThemeData(
  primarySwatch: Colors.red,
  accentColor: Colors.red,
  primaryColor: Colors.red,
  brightness: Brightness.dark,
  fontFamily: 'Montserrat',
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.grey[900],
    brightness: Brightness.dark,
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(color: Colors.white),
    headline5: HeadingSmall.copyWith(color: Colors.white),
    bodyText2: BodyStyle1.copyWith(color: Colors.white),
  ),
  cardTheme: CardTheme(color: Colors.grey[900]),
);

final cupertino = CupertinoThemeData(
  brightness: Brightness.dark,
);
