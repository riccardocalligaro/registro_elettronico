import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesUpdateLoading extends NotesState {}

class NotesUpdateLoaded extends NotesState {}

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
