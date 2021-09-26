import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';

abstract class NotesRepository {
  // Update the lessons from spaggiari
  Future updateNotes();

  Future<List<Note>> getAllNotes();

  Future<NotesReadResponse> readNote(String type, int eventId);

  Future insertNote(Note note);

  Future<NotesAttachment> getAttachmentForNote(String? type, int? eventId);

  Future deleteAllNotes();

  Future deleteAllAttachments();
}
