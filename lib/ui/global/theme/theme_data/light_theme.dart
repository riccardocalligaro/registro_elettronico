import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/theme/theme_data/text_styles.dart';

final material = ThemeData(
  primarySwatch: Colors.red,
  accentColor: Colors.red,
  brightness: Brightness.light,
  fontFamily: 'Montserrat',
  //canvasColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 1,
    color: Colors.white,
  ),
  primaryIconTheme: IconThemeData(color: Colors.grey[900], opacity: 0.50),
  primaryTextTheme: TextTheme(
    title: TextStyle(
      color: Colors.grey[900],
    ),
    headline: HeadingSmall.copyWith(color: Colors.grey[900]),
    body1: BodyStyle1.copyWith(color: Colors.grey[900]),
  ),
);

final cupertino = CupertinoThemeData(
  brightness: Brightness.light,
);
