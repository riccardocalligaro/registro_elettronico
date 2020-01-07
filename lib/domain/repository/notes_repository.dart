import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';

abstract class NotesRepository {
  // Update the lessons from spaggiari
  Future updateNotes();

  Future<List<Note>> getAllNotes();

  Future insertNote(Note note);

  Future deleteAllNotes();

  Future<NotesReadResponse> readNote(String type, int eventId);
}
