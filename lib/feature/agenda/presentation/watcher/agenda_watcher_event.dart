part of 'agenda_watcher_bloc.dart';

@immutable
abstract class AgendaWatcherEvent {}

class AgendaWatchAllStarted extends AgendaWatcherEvent {}

class AgendaDataReceived extends AgendaWatcherEvent {
  final Resource<AgendaDataDomainModel> resource;

  AgendaDataReceived({
    required this.resource,
  });
}
