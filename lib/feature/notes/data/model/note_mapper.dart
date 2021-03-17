// TextColumn get author => text()();
// DateTimeColumn get date => dateTime()();
// IntColumn get id => integer()();
// BoolColumn get status => boolean()();
// TextColumn get description => text()();
// TextColumn get warning => text()();
// TextColumn get type => text()();

import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/notes/data/model/remote/note_remote_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class NoteMapper {
  static db.Note convertNotetEntityToInsertable(
      NoteRemoteModel note, String type) {
    return db.Note(
      author: note.authorName ?? '',
      date: SRDateUtils.getDateFromApiString(note.evtDate) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      id: note.evtId ?? GlobalUtils.getRandomNumber(),
      status: note.readStatus ?? false,
      description: note.extText ?? '',
      warning: note.warningType ?? '',
      type: type ?? '',
    );
  }

  static db.NotesAttachment convertNoteAttachmentResponseToInsertable(
    NotesReadResponse res,
  ) {
    return db.NotesAttachment(
      id: res.event.evtId ?? -1,
      type: res.event.evtCode ?? '',
      description: res.event.evtText ?? '',
    );
  }
}
