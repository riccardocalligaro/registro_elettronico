import 'package:meta/meta.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';

@immutable
abstract class NoteAttachmentsState {}

class NoteAttachmentsInitial extends NoteAttachmentsState {}

class NoteAttachmentsLoadInProgress extends NoteAttachmentsState {}

class NoteAttachmentsLoadSuccess extends NoteAttachmentsState {
  final NotesReadResponse readResponse;

  NoteAttachmentsLoadSuccess({
    @required this.readResponse,
  });
}

class NoteAttachmentsLoadError extends NoteAttachmentsState {
  final String error;

  NoteAttachmentsLoadError({@required this.error});
}
