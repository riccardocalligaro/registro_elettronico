import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/feature/notes/data/model/note_local_model.dart';

part '../../../feature/notes/data/dao/note_dao.g.dart';

@UseDao(tables: [Notes, NotesAttachments])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  AppDatabase db;
  NoteDao(this.db) : super(db);

  Future<List<Note>> getAllNotes() => select(notes).get();

  Future<List<NotesAttachment>> getAllAttachments() =>
      select(notesAttachments).get();

  Future insertAttachment(NotesAttachment attachment) =>
      into(notesAttachments).insert(attachment, orReplace: true);

  Future insertNote(Note note) => into(notes).insert(note, orReplace: true);

  Future insertNotes(List<Note> notesList) =>
      into(notes).insertAll(notesList, orReplace: true);

  Future insertAttachments(List<NotesAttachment> notesAttachmentsList) =>
      into(notesAttachments).insertAll(notesAttachmentsList, orReplace: true);

  Future deleteAllNotes() => delete(notes).go();

  Future deleteAllAttachments() => delete(notesAttachments).go();
}
