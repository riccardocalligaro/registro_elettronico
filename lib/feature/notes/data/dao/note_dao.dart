import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/notes/data/model/local/note_local_model.dart';

part 'note_dao.g.dart';

@UseDao(tables: [Notes, NotesAttachments])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  AppDatabase db;

  NoteDao(this.db) : super(db);

  Future<List<Note>> getAllNotes() => select(notes).get();

  Future<List<NotesAttachment>> getAllAttachments() =>
      select(notesAttachments).get();

  Future insertAttachment(NotesAttachment attachment) =>
      into(notesAttachments).insertOnConflictUpdate(attachment);

  Future insertNote(Note note) => into(notes).insertOnConflictUpdate(note);

  Future<void> insertNotes(List<Note> notesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(notes, notesList);
    });
  }

  Future<void> insertAttachments(
      List<NotesAttachment> notesAttachmentsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(notesAttachments, notesAttachmentsList);
    });
  }

  Future deleteAllNotes() => delete(notes).go();

  Future deleteAllAttachments() => delete(notesAttachments).go();
}
