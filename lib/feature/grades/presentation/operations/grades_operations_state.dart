part of 'grades_operations_bloc.dart';

@immutable
abstract class GradesOperationsState {}

class GradesOperationsInitial extends GradesOperationsState {}

class GradeOperationFailure extends GradesOperationsState {
  final Failure failure;

  GradeOperationFailure({
    required this.failure,
  });
}

class GradeOperationSuccess extends GradesOperationsState {}
