import 'package:meta/meta.dart';

@immutable
abstract class IntroState {}

class IntroInitial extends IntroState {}

class IntroLoading extends IntroState {
  final int progress;

  IntroLoading(this.progress);
}

class IntroLoaded extends IntroState {}

class IntroError extends IntroState {
  final String error;

  IntroError(this.error);
}
