import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../app_themes.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;

  ThemeChanged({@required this.theme});
}
