import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocalizationsEvent extends Equatable {
  const LocalizationsEvent();
}

class LocaleChanged extends LocalizationsEvent {
  final Locale locale;

  const LocaleChanged({required this.locale});

  @override
  List<Object?> get props => [locale.languageCode, locale.countryCode];
}
