import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/notes/data/model/note_mapper.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  NoteDao noteDao;
  SpaggiariClient spaggiariClient;
  ProfileDao profileDao;
  NetworkInfo networkInfo;

  NotesRepositoryImpl(
    this.noteDao,
    this.spaggiariClient,
    this.profileDao,
    this.networkInfo,
  );

  @override
  Future deleteAllNotes() {
    return noteDao.deleteAllNotes();
  }

  @override
  Future<List<Note>> getAllNotes() {
    return noteDao.getAllNotes();
  }

  @override
  Future insertNote(Note note) {
    return noteDao.insertNote(note);
  }

  @override
  Future updateNotes() async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();

      final notesResponse = await spaggiariClient.getNotes(profile.studentId);

      List<Note> notes = [];
      notesResponse.notesNTCL.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTCL')));
      notesResponse.notesNTWN.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTWN')));
      notesResponse.notesNTTE.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTTE')));
      notesResponse.notesNTST.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTST')));

      FLog.info(
        text:
            'Got ${notesResponse.notesNTCL.length} notesNTCL from server, procceding to insert in database',
      );
      FLog.info(
        text:
            'Got ${notesResponse.notesNTWN.length} notesNTWN from server, procceding to insert in database',
      );
      FLog.info(
        text:
            'Got ${notesResponse.notesNTTE.length} notesNTTE from server, procceding to insert in database',
      );
      FLog.info(
        text:
            'Got ${notesResponse.notesNTST.length} notesNTST from server, procceding to insert in database',
      );
      await noteDao.deleteAllAttachments();
      await noteDao.deleteAllNotes();

      await noteDao.insertNotes(notes);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<NotesReadResponse> readNote(String type, int eventId) async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();

      final res =
          await spaggiariClient.markNote(profile.studentId, type, eventId, "");
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future deleteAllAttachments() {
    return noteDao.deleteAllAttachments();
  }

  @override
  Future<NotesAttachment> getAttachmentForNote(String type, int eventId) async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();
      final attachments = await noteDao.getAllAttachments();

      for (var attachment in attachments) {
        if (attachment.id == eventId) return attachment;
      }

      final res =
          await spaggiariClient.markNote(profile.studentId, type, eventId, "");
      final insertable =
          NoteMapper.convertNoteAttachmentResponseToInsertable(res);
          
      await noteDao.deleteAllAttachments();
      noteDao.insertAttachment(insertable);

      return insertable;
    } else {
      throw NotConntectedException();
    }
  }
}
