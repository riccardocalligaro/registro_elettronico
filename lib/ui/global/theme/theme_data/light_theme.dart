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
  primaryIconTheme: IconThemeData(
    color: Colors.grey[800],
  ),
  primaryTextTheme: TextTheme(
    title: TextStyle(color: Colors.black),
    headline: HeadingSmall.copyWith(color: Colors.black),
    body1: BodyStyle1.copyWith(color: Colors.black),
  ),
);

final cupertino = CupertinoThemeData(
  brightness: Brightness.light,
);
