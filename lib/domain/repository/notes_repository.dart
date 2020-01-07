import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';

abstract class NotesRepository {
  // Update the lessons from spaggiari
  Future updateNotes();

  Future<List<Note>> getAllNotes();

  Future<NotesReadResponse> readNote(String type, int eventId);

  Future insertNote(Note note);

  Future<NotesAttachment> getAttachmentForNote(String type, int eventId);

  Future deleteAllNotes();

  Future deleteAllAttachments();
}
