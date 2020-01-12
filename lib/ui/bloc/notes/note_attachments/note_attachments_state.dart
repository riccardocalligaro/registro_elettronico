import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class NoteAttachmentsState {}

class NoteAttachmentsInitial extends NoteAttachmentsState {}

class NoteAttachmentsLoadInProgress extends NoteAttachmentsState {}

class NoteAttachmentsLoadSuccess extends NoteAttachmentsState {
  final NotesAttachment attachment;

  NoteAttachmentsLoadSuccess({
    @required this.attachment,
  });
}

class NoteAttachmentsLoadError extends NoteAttachmentsState {
  final String error;

  NoteAttachmentsLoadError({@required this.error});
}
