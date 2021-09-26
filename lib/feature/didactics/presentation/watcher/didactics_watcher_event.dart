part of 'didactics_watcher_bloc.dart';

@immutable
abstract class DidacticsWatcherEvent {}

class DidacticsWatchAllStarted extends DidacticsWatcherEvent {}

class DidacticsDataReceived extends DidacticsWatcherEvent {
  final Resource<List<DidacticsTeacherDomainModel?>> resource;

  DidacticsDataReceived({
    required this.resource,
  });
}
