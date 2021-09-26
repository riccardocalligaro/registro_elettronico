part of 'note_attachments_bloc.dart';

@immutable
abstract class NoteAttachmentsState {}

class NoteAttachmentsInitial extends NoteAttachmentsState {}

class NoteAttachmentsLoadInProgress extends NoteAttachmentsState {}

class NoteAttachmentsLoadNotConnected extends NoteAttachmentsState {}

class NoteAttachmentsLoadSuccess extends NoteAttachmentsState {
  final NotesAttachment attachment;

  NoteAttachmentsLoadSuccess({
    required this.attachment,
  });
}

class NoteAttachmentsLoadError extends NoteAttachmentsState {
  final String error;

  NoteAttachmentsLoadError({required this.error});
}
