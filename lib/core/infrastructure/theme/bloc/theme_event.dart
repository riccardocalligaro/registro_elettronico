import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/themes.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final ThemeType? type;
  final MaterialColor? color;

  ThemeChanged({
    required this.type,
    required this.color,
  });
}
