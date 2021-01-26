part of 'subjects_watcher_bloc.dart';

@immutable
abstract class SubjectsWatcherState {}

class SubjectsWatcherInitial extends SubjectsWatcherState {}

class SubjectsWatcherLoading extends SubjectsWatcherState {}

class SubjectsWatcherLoadSuccess extends SubjectsWatcherState {
  final List<SubjectDomainModel> subjects;

  SubjectsWatcherLoadSuccess({
    @required this.subjects,
  });
}

class SubjectsWatcherFailure extends SubjectsWatcherState {
  final Failure failure;

  SubjectsWatcherFailure({@required this.failure});
}
