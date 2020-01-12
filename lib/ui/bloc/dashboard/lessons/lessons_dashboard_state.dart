import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class LessonsDashboardState {}

class LessonsDashboardInitial extends LessonsDashboardState {}

class LessonsDashboardLoadInProgress extends LessonsDashboardState {}

class LessonsDashboardLoadSuccess extends LessonsDashboardState {
  final List<Lesson> lessons;

  LessonsDashboardLoadSuccess({@required this.lessons});
}

class LessonsDashboardLoadError extends LessonsDashboardState {}
