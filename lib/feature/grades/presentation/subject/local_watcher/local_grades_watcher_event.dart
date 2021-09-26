part of 'local_grades_watcher_bloc.dart';

@immutable
abstract class LocalGradesWatcherEvent {}

class LocalGradesWatchAllStarted extends LocalGradesWatcherEvent {
  final int? subjectId;
  final int? periodPos;

  LocalGradesWatchAllStarted({
    required this.subjectId,
    required this.periodPos,
  });
}

class LocalGradesReceived extends LocalGradesWatcherEvent {
  final Resource<List<GradeDomainModel>> resource;

  LocalGradesReceived({
    required this.resource,
  });
}
