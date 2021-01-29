part of 'subject_grades_pageset_bloc.dart';

@immutable
abstract class SubjectGradesPagesetState {}

class SubjectGradesPagesetInitial extends SubjectGradesPagesetState {}

class SubjectGradesPagesetLoading extends SubjectGradesPagesetState {}

class SubjectGradesPagesetLoaded extends SubjectGradesPagesetState {
  final SubjectDataDomainModel subjectDataDomainModel;

  SubjectGradesPagesetLoaded({
    @required this.subjectDataDomainModel,
  });
}

class SubjectGradesPagesetFailure extends SubjectGradesPagesetState {
  final Failure failure;

  SubjectGradesPagesetFailure({
    @required this.failure,
  });
}
