part of 'timetable_watcher_bloc.dart';

@immutable
abstract class TimetableWatcherState {}

class TimetableWatcherInitial extends TimetableWatcherState {}

class TimetableWatcherLoading extends TimetableWatcherState {}

class TimetableWatcherLoadSuccess extends TimetableWatcherState {
  final TimetableDataDomainModel timetableData;

  TimetableWatcherLoadSuccess({
    @required this.timetableData,
  });
}

class TimetableWatcherFailure extends TimetableWatcherState {
  final Failure failure;

  TimetableWatcherFailure({@required this.failure});
}
