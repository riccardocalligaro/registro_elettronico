import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/note_mapper.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';

class NotesRepositoryImpl implements NotesRepository {
  NoteDao noteDao;
  SpaggiariClient spaggiariClient;
  ProfileDao profileDao;
  NoteMapper noteMapper;
  NotesRepositoryImpl(
    this.noteDao,
    this.spaggiariClient,
    this.profileDao,
    this.noteMapper,
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
    Logger log = Logger();
    final profile = await profileDao.getProfile();
    log.i("UPDATING NOTES");
    await noteDao.deleteAllNotes();
    final notesResponse = await spaggiariClient.getNotes(profile.studentId);
    log.i("Got NOTES");

    List<Note> notes = [];
    notesResponse.notesNTCL.forEach((note) =>
        notes.add(noteMapper.convertNotetEntityToInsertable(note, 'NTCL')));
    notesResponse.notesNTWN.forEach((note) =>
        notes.add(noteMapper.convertNotetEntityToInsertable(note, 'NTWN')));
    notesResponse.notesNTTE.forEach((note) =>
        notes.add(noteMapper.convertNotetEntityToInsertable(note, 'NTTE')));
    notesResponse.notesNTST.forEach((note) =>
        notes.add(noteMapper.convertNotetEntityToInsertable(note, 'NTST')));

    await noteDao.insertNotes(notes);
  }

  @override
  Future<NotesReadResponse> readNote(String type, int eventId) async {
    final profile = await profileDao.getProfile();

    final res =
        await spaggiariClient.markNote(profile.studentId, type, eventId);
    return res;
  }
}
