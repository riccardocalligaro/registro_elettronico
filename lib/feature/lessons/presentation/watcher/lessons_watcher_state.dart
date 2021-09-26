part of 'lessons_watcher_bloc.dart';

@immutable
abstract class LessonsWatcherState {}

class LessonsWatcherInitial extends LessonsWatcherState {}

class LessonsWatcherLoading extends LessonsWatcherState {}

class LessonsWatcherLoadSuccess extends LessonsWatcherState {
  final List<LessonDomainModel>? lessons;

  LessonsWatcherLoadSuccess({
    required this.lessons,
  });
}

class LessonsWatcherFailure extends LessonsWatcherState {
  final Failure? failure;

  LessonsWatcherFailure({required this.failure});
}
