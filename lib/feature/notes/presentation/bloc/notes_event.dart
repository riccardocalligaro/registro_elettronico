part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class UpdateNotes extends NotesEvent {}

class GetNotes extends NotesEvent {}

