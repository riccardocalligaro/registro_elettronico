part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesUpdateLoading extends NotesState {}

class NotesUpdateLoaded extends NotesState {}

class NotesLoadErrorNotConnected extends NotesState {}

class NotesUpdateError extends NotesState {
  final String error;

  NotesUpdateError(this.error);
}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  NotesLoaded(this.notes);
}

class NotesError extends NotesState {
  final String message;

  NotesError(this.message);
}
