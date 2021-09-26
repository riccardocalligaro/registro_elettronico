part of 'latest_lessons_watcher_bloc.dart';

@immutable
abstract class LatestLessonsWatcherEvent {}

class LatestLessonsReceived extends LatestLessonsWatcherEvent {
  final Resource<List<LessonWithDurationDomainModel>> resource;

  LatestLessonsReceived({
    required this.resource,
  });
}
