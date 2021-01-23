part of 'timetable_watcher_bloc.dart';

@immutable
abstract class TimetableWatcherState {}

class TimetableWatcherInitial extends TimetableWatcherState {}

class TimetableWatcherLoading extends TimetableWatcherState {}

class TimetableWatcherLoadSuccess extends TimetableWatcherState {
  final List<TimetableEntryPresentationModel> timetable;

  TimetableWatcherLoadSuccess({
    @required this.timetable,
  });
}

class TimetableWatcherFailure extends TimetableWatcherState {
  final Failure failure;

  TimetableWatcherFailure({@required this.failure});
}
