import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import './bloc.dart';

class NoteAttachmentsBloc
    extends Bloc<NoteAttachmentsEvent, NoteAttachmentsState> {
  NotesRepository notesRepository;

  NoteAttachmentsBloc(this.notesRepository);
  @override
  NoteAttachmentsState get initialState => NoteAttachmentsInitial();

  @override
  Stream<NoteAttachmentsState> mapEventToState(
    NoteAttachmentsEvent event,
  ) async* {
    if (event is ReadNote) {
      yield* _mapReadNoteToState(event.type, event.eventId);
    }
  }

  Stream<NoteAttachmentsState> _mapReadNoteToState(String type, int id) async* {
    yield NoteAttachmentsLoadInProgress();
    try {
      final attachment = await notesRepository.getAttachmentForNote(type, id);
      yield NoteAttachmentsLoadSuccess(attachment: attachment);
    } catch (e) {
      yield NoteAttachmentsLoadError(error: e.toString());
    }
  }
}
