part of 'latest_lessons_watcher_bloc.dart';

@immutable
abstract class LatestLessonsWatcherState {}

class LatestLessonsWatcherInitial extends LatestLessonsWatcherState {}

class LatestLessonsWatcherLoading extends LatestLessonsWatcherState {}

class LatestLessonsWatcherLoadSuccess extends LatestLessonsWatcherState {
  final List<LessonWithDurationDomainModel>? lessons;

  LatestLessonsWatcherLoadSuccess({
    required this.lessons,
  });
}

class LatestLessonsWatcherFailure extends LatestLessonsWatcherState {
  final Failure? failure;

  LatestLessonsWatcherFailure({required this.failure});
}
