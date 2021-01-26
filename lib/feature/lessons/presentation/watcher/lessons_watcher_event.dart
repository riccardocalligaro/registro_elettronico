part of 'lessons_watcher_bloc.dart';

@immutable
abstract class LessonsWatcherEvent {}

class LessonsWatchAllStarted extends LessonsWatcherEvent {
  final int subjectId;

  LessonsWatchAllStarted({
    @required this.subjectId,
  });
}

class LessonsReceived extends LessonsWatcherEvent {
  final Resource<List<LessonDomainModel>> resource;

  LessonsReceived({
    @required this.resource,
  });
}

class LessonsRestartWatcher extends LessonsWatcherEvent {
  final int subjectId;

  LessonsRestartWatcher({
    @required this.subjectId,
  });
}
