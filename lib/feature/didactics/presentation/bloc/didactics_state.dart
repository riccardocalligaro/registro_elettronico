part of 'didactics_bloc.dart';

@immutable
abstract class DidacticsState {}

class DidacticsInitial extends DidacticsState {}

class DidacticsLoading extends DidacticsState {}

class DidacticsLoaded extends DidacticsState {
  final List<DidacticsTeacher> teachers;
  final List<DidacticsFolder> folders;
  final List<DidacticsContent> contents;

  DidacticsLoaded({
    @required this.teachers,
    @required this.folders,
    @required this.contents,
  });
}

class DidacticsError extends DidacticsState {
  final String error;

  DidacticsError(this.error);
}

/// Updates

class DidacticsUpdateLoading extends DidacticsState {}

class DidacticsUpdateLoaded extends DidacticsState {}

class DidacticsErrorNotConnected extends DidacticsState {}


class DidacticsUpdateError extends DidacticsState {
  final String error;

  DidacticsUpdateError(this.error);
}
