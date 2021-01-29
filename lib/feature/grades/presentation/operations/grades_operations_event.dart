part of 'grades_operations_bloc.dart';

@immutable
abstract class GradesOperationsEvent {}

class ToggleGradeLocallyCancelledState extends GradesOperationsEvent {
  final GradeDomainModel gradeDomainModel;

  ToggleGradeLocallyCancelledState({
    @required this.gradeDomainModel,
  });
}

class ChangeSubjectObjective extends GradesOperationsEvent {
  final SubjectDomainModel subject;
  final int newValue;

  ChangeSubjectObjective({
    @required this.newValue,
    @required this.subject,
  });
}
