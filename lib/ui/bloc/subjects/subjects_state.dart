import 'package:meta/meta.dart';

@immutable
abstract class SubjectsState {}

class SubjectsNotLoaded extends SubjectsState {}

class SubjectsLoading extends SubjectsState {}

class SubjectsError extends SubjectsState {
  final String error;

  SubjectsError(this.error);
}

class SubjectsLoaded extends SubjectsState {}
