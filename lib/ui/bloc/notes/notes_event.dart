import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class UpdateNotes extends NotesEvent {}

class GetNotes extends NotesEvent {}
