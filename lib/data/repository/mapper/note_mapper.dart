// TextColumn get author => text()();
// DateTimeColumn get date => dateTime()();
// IntColumn get id => integer()();
// BoolColumn get status => boolean()();
// TextColumn get description => text()();
// TextColumn get warning => text()();
// TextColumn get type => text()();

import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_response.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class NoteMapper {
  db.Note convertNotetEntityToInsertable(Note note, String type) {
    return db.Note(
      author: note.authorName ?? "",
      date: DateUtils.getDateFromApiString(note.evtDate) ?? DateTime.now(),
      id: note.evtId ?? GlobalUtils.getRandomNumber(),
      status: note.readStatus ?? false,
      description: note.extText ?? "",
      warning: note.warningType ?? "",
      type: type ?? "",
    );
  }

  db.NotesAttachment convertNoteAttachmentResponseToInsertable(
    NotesReadResponse res,
  ) {
    return db.NotesAttachment(
      id: res.event.evtId,
      type: res.event.evtCode,
      description: res.event.evtText,
    );
  }
}
