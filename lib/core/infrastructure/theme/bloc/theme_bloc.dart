import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/black_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/dark_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/light_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/themes.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  //static const String DARK_THEME = "ThemeBloc_DARK_THEME";

  static ThemeBloc _instance;

  SharedPreferences prefs;

  ThemeBloc()
      : super(ThemeState(
          materialThemeData: DarkTheme.getThemeData(Colors.red),
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
      ThemeType _themeType;

      if (event.type == null) {
        _themeType = _typeFromString(
            prefs.getString(PrefsConstants.themeType) ??
                ThemeType.dark.toString());
      } else {
        _themeType = event.type;
      }

      if (_themeType == ThemeType.dark || _themeType == ThemeType.black) {
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

      await _saveSettings(_themeType, color);

      yield ThemeState(
        materialThemeData: _getThemeData(_themeType, color),
      );
    }
  }

  ThemeData _getThemeData(ThemeType themeType, Color color) {
    if (themeType == ThemeType.dark) {
      return DarkTheme.getThemeData(color);
    } else if (themeType == ThemeType.black) {
      return BlackTheme.getThemeData(color);
    } else {
      return LightTheme.getThemeData(color);
    }
  }

  Future<void> _loadSettings() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    // bool _darkTheme = prefs.getBool(PrefsConstants.DARK_THEME) ?? true;
    ThemeType _themeType = _typeFromString(
        prefs.getString(PrefsConstants.themeType) ?? ThemeType.dark);

    Color _themeColor = ColorUtils.createMaterialColor(
        Color(prefs.getInt(PrefsConstants.themeColor)));

    add(ThemeChanged(
      type: _themeType,
      color: _themeColor,
    ));
  }

  Future<void> _saveSettings(ThemeType themeType, MaterialColor color) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsConstants.themeType, themeType.toString());

    await prefs.setInt(PrefsConstants.themeColor, color.shade500.value);
  }

  ThemeType _typeFromString(String type) {
    return ThemeType.values.firstWhere((e) => e.toString() == type);
  }
}
