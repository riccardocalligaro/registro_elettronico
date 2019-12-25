import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class NotesRepository {
  // Update the lessons from spaggiari
  Future updateNotes();

  Future<List<Note>> getUpdatedNotes();

  Future<List<Note>> getAllNotes();

  Future insertNote(Note note);

  Future deleteAllNotes();
}
