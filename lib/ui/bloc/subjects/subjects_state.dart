import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class SubjectsState {}

class SubjectsInitial extends SubjectsState {}

class SubjectsUpdateLoading extends SubjectsState {}

class SubjectsUpdateError extends SubjectsState {
  final String error;

  SubjectsUpdateError(this.error);
}

class SubjectsUpdateLoaded extends SubjectsState {}

class SubjectsLoading extends SubjectsState {}

class SubjectsError extends SubjectsState {
  final String error;

  SubjectsError(this.error);
}

class SubjectsLoaded extends SubjectsState {
  final List<Subject> subjects;

  SubjectsLoaded(this.subjects);
}
