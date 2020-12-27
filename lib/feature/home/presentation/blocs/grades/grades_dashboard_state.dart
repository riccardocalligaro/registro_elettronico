part of 'grades_dashboard_bloc.dart';

@immutable
abstract class GradesDashboardState {}

class GradesDashboardInitial extends GradesDashboardState {}

class GradesDashboardLoadInProgress extends GradesDashboardState {}

class GradesDashboardLoadSuccess extends GradesDashboardState {
  final List<Grade> grades;

  GradesDashboardLoadSuccess({@required this.grades});
}

class GradesDashboardLoadError extends GradesDashboardState {}

