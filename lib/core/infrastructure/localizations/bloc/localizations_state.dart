import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LocalizationsState extends Equatable {
  final Locale locale;
  const LocalizationsState({required this.locale});

  @override
  List<Object?> get props => [locale.countryCode, locale.languageCode];
}
