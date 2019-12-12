import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/themes/theme_data/text_styles.dart';

final mainTextTheme = TextTheme(headline: HeadingSmall, body1: BodyStyle1);

final defaultTheme = ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.red,
    primaryColor: Colors.blue,
    textTheme: mainTextTheme,
    fontFamily: 'Montserrat');
