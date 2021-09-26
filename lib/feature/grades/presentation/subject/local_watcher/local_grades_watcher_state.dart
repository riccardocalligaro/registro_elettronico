part of 'local_grades_watcher_bloc.dart';

@immutable
abstract class LocalGradesWatcherState {}

class LocalGradesWatcherInitial extends LocalGradesWatcherState {}

class LocalGradesWatcherLoading extends LocalGradesWatcherState {}

class LocalGradesWatcherLoadSuccess extends LocalGradesWatcherState {
  final List<GradeDomainModel>? grades;

  LocalGradesWatcherLoadSuccess({
    required this.grades,
  });
}

class LocalGradesWatcherFailure extends LocalGradesWatcherState {
  final Failure? failure;

  LocalGradesWatcherFailure({required this.failure});
}
