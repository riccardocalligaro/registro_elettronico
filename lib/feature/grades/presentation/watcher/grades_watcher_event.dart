part of 'grades_watcher_bloc.dart';

@immutable
abstract class GradesWatcherEvent {}

class WatchAllStarted extends GradesWatcherEvent {}

class GradesReceived extends GradesWatcherEvent {
  final Resource<GradesPagesDomainModel> resource;

  GradesReceived({
    required this.resource,
  });
}

class RestartWatcher extends GradesWatcherEvent {}
