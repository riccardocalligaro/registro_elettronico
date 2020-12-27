part of 'subjects_bloc.dart';

@immutable
abstract class SubjectsState {}

class SubjectsInitial extends SubjectsState {}

// Updates
class SubjectsUpdateLoadInProgress extends SubjectsState {}

class SubjectsUpdateLoadError extends SubjectsState {
  final String error;

  SubjectsUpdateLoadError({@required this.error});
}

class SubjectsUpdateLoadSuccess extends SubjectsState {}

// Subjects

class SubjectsLoadInProgress extends SubjectsState {}

class SubjectsLoadError extends SubjectsState {
  final String error;

  SubjectsLoadError({@required this.error});
}

class SubjectsLoadSuccess extends SubjectsState {
  final List<Subject> subjects;

  SubjectsLoadSuccess({@required this.subjects});
}

// Subjects and professors

class SubjectsAndProfessorsLoadInProgress extends SubjectsState {}

class SubjectsAndProfessorsLoadSuccess extends SubjectsState {
  final List<Subject> subjects;
  final List<Professor> professors;

  SubjectsAndProfessorsLoadSuccess({
    @required this.subjects,
    @required this.professors,
  });
}

class SubjectsAndProfessorsLoadError extends SubjectsState {
  final String error;

  SubjectsAndProfessorsLoadError({@required this.error});
}

// Professors

class ProfessorsLoadInProgress extends SubjectsState {}

class ProfessorsLoadSuccess extends SubjectsState {
  final List<Professor> professors;

  ProfessorsLoadSuccess({@required this.professors});
}

class ProfessorsLoadError extends SubjectsState {
  final String error;

  ProfessorsLoadError({@required this.error});
}
