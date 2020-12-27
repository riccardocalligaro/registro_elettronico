part of 'professors_bloc.dart';

@immutable
abstract class ProfessorsState {}

class ProfessorsInitial extends ProfessorsState {}

class ProfessorsLoadInProgress extends ProfessorsState {}

class ProfessorsLoadSuccess extends ProfessorsState {
  final List<Professor> professors;

  ProfessorsLoadSuccess({@required this.professors});
}

class ProfessorsLoadError extends ProfessorsState {}
