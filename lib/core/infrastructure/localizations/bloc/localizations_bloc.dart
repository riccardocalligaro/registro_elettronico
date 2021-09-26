import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc.dart';

class LocalizationsBloc extends Bloc<LocalizationsEvent, LocalizationsState> {
  static LocalizationsBloc? _instance;

  static const String localeKey = "LocalizationsBloc_LOCALE";

  SharedPreferences? prefs;

  LocalizationsBloc() : super(LocalizationsState(locale: ui.window.locale)) {
    _loadSettings();
  }

  static LocalizationsBloc? get instance {
    if (_instance == null) {
      _instance = LocalizationsBloc();
    }
    return _instance;
  }

  @override
  Stream<LocalizationsState> mapEventToState(
    LocalizationsEvent event,
  ) async* {
    if (event is LocaleChanged) {
      await _saveSettings(event.locale);
      yield LocalizationsState(locale: event.locale);
    }
  }

  void _loadSettings() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    List<String>? localeString = prefs!.getStringList(localeKey);
    if (localeString != null) {
      ui.Locale locale =
          ui.Locale(localeString.elementAt(0), localeString.elementAt(1));

      add(LocaleChanged(locale: locale));
    }
  }

  Future<void> _saveSettings(Locale locale) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    await prefs!
        .setStringList(localeKey, [locale.languageCode, locale.countryCode!]);
  }
}
