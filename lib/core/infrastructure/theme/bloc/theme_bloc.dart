import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/dark_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/light_theme.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_themes.dart';
import 'bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  //static const String DARK_THEME = "ThemeBloc_DARK_THEME";

  static ThemeBloc _instance;

  SharedPreferences prefs;

  ThemeBloc()
      : super(ThemeState(
          materialThemeData: DarkTheme.getThemeData(Colors.red),
          cupertinoThemeData: cupertinoThemeData[AppTheme.dark],
        )) {
    _loadSettings();
  }

  static ThemeBloc get instance {
    if (_instance == null) {
      _instance = ThemeBloc();
    }
    return _instance;
  }

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      bool darkTheme;

      if (event.theme == null) {
        darkTheme = prefs.getBool(PrefsConstants.DARK_THEME) ?? true;
      } else {
        darkTheme = event.theme == AppTheme.dark;
      }

      if (darkTheme) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: null,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ));
      }
      final MaterialColor color = event.color ??
          ColorUtils.createMaterialColor(Color(
              prefs.getInt(PrefsConstants.themeColor) ?? Colors.red.value));

      await _saveSettings(darkTheme, color);

      yield ThemeState(
        materialThemeData: darkTheme
            ? DarkTheme.getThemeData(color)
            : LightTheme.getThemeData(color),
        cupertinoThemeData: cupertinoThemeData[event.theme],
      );
    }
  }

  Future<bool> _loadSettings() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    bool _darkTheme = prefs.getBool(PrefsConstants.DARK_THEME) ?? true;
    Color _themeColor = ColorUtils.createMaterialColor(
        Color(prefs.getInt(PrefsConstants.themeColor)));

    add(ThemeChanged(
      theme: _darkTheme ? AppTheme.dark : AppTheme.light,
      color: _themeColor,
    ));

    return _darkTheme;
  }

  Future<void> _saveSettings(bool darkTheme, MaterialColor color) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsConstants.DARK_THEME, darkTheme);

    await prefs.setInt(PrefsConstants.themeColor, color.shade500.value);
  }
}
