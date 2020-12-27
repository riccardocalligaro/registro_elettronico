part of 'lessons_dashboard_bloc.dart';

@immutable
abstract class LessonsDashboardState {}

class LessonsDashboardInitial extends LessonsDashboardState {}

class LessonsDashboardLoadInProgress extends LessonsDashboardState {}

class LessonsDashboardLoadSuccess extends LessonsDashboardState {
  final List<Lesson> lessons;

  LessonsDashboardLoadSuccess({@required this.lessons});
}

class LessonsDashboardLoadError extends LessonsDashboardState {}
