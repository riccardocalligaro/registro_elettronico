import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/core/error/failures.dart';
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
      FLog.info(text: 'Got attachment ${attachment.id}');
      yield NoteAttachmentsLoadSuccess(attachment: attachment);
    } catch (e, s) {
      FLog.error(
        text: 'Error reading note',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);
      yield NoteAttachmentsLoadError(error: e.toString());
    }
  }
}
