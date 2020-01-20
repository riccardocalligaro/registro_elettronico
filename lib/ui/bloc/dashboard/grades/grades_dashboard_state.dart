import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class GradesDashboardState {}

class GradesDashboardInitial extends GradesDashboardState {}

class GradesDashboardLoadInProgress extends GradesDashboardState {}

class GradesDashboardLoadSuccess extends GradesDashboardState {
  final List<Grade> grades;

  GradesDashboardLoadSuccess({@required this.grades});
}

class GradesDashboardLoadError extends GradesDashboardState {}
