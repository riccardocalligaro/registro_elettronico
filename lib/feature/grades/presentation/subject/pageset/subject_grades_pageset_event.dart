part of 'subject_grades_pageset_bloc.dart';

@immutable
abstract class SubjectGradesPagesetEvent {}

class GetSubjectGradesPageset extends SubjectGradesPagesetEvent {
  final PeriodGradeDomainModel periodGradeDomainModel;

  GetSubjectGradesPageset({
    @required this.periodGradeDomainModel,
  });
}
