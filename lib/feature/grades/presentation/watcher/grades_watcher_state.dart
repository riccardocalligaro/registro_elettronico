part of 'grades_watcher_bloc.dart';

@immutable
abstract class GradesWatcherState {}

class GradesWatcherInitial extends GradesWatcherState {}

class GradesWatcherLoading extends GradesWatcherState {}

class GradesWatcherLoadSuccess extends GradesWatcherState {
  final GradesPagesDomainModel gradesSections;

  GradesWatcherLoadSuccess({
    @required this.gradesSections,
  });
}

class GradesWatcherFailure extends GradesWatcherState {
  final Failure failure;

  GradesWatcherFailure({@required this.failure});
}
