part of 'timetable_watcher_bloc.dart';

@immutable
abstract class TimetableWatcherEvent {}

class TimetableReceived extends TimetableWatcherEvent {
  final Resource<List<TimetableEntryPresentationModel>> resource;

  TimetableReceived({
    @required this.resource,
  });
}

class TimetableStartWatcherIfNeeded extends TimetableWatcherEvent {}

class TimetableRestartWatcher extends TimetableWatcherEvent {}
