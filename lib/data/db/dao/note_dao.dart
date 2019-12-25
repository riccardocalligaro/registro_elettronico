import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/note_table.dart';

part 'note_dao.g.dart';

@UseDao(tables: [Notes])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  AppDatabase db;
  NoteDao(this.db) : super(db);

  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  Future<List<Note>> getAllNotes() => select(notes).get();

  Future insertNote(Note note) => into(notes).insert(note, orReplace: true);

  Future deleteAllNotes() => delete(notes).go();
}
