import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';

part 'note_attachments_event.dart';
part 'note_attachments_state.dart';

class NoteAttachmentsBloc
    extends Bloc<NoteAttachmentsEvent, NoteAttachmentsState> {
  final NotesRepository notesRepository;

  NoteAttachmentsBloc({
    @required this.notesRepository,
  }) : super(NoteAttachmentsInitial());

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
    } on NotConntectedException {
      yield NoteAttachmentsLoadNotConnected();
    } catch (e, s) {
      FLog.error(
        text: 'Error reading note',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield NoteAttachmentsLoadError(error: e.toString());
    }
  }
}
