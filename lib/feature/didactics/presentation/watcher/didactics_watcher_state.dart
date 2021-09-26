part of 'didactics_watcher_bloc.dart';

@immutable
abstract class DidacticsWatcherState {}

class DidacticsWatcherInitial extends DidacticsWatcherState {}

class DidacticsWatcherLoading extends DidacticsWatcherState {}

class DidacticsWatcherLoadSuccess extends DidacticsWatcherState {
  final List<DidacticsTeacherDomainModel?>? teachers;

  DidacticsWatcherLoadSuccess({
    required this.teachers,
  });
}

class DidacticsWatcherFailure extends DidacticsWatcherState {
  final Failure? failure;

  DidacticsWatcherFailure({required this.failure});
}
