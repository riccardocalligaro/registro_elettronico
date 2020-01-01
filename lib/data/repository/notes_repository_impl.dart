import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/note_mapper.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';

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
    final profile = await profileDao.getProfile();
    final notesResponse = await spaggiariClient.getNotes(profile.studentId);
    notesResponse.notesNTCL.forEach(
        (note) => noteMapper.convertNotetEntityToInsertable(note, 'NTCL'));
    notesResponse.notesNTWN.forEach(
        (note) => noteMapper.convertNotetEntityToInsertable(note, 'NTWN'));
    notesResponse.notesNTTE.forEach(
        (note) => noteMapper.convertNotetEntityToInsertable(note, 'NTTE'));
    notesResponse.notesNTST.forEach(
        (note) => noteMapper.convertNotetEntityToInsertable(note, 'NTST'));
  }

  @override
  Future<List<Note>> getUpdatedNotes() {
    // TODO: implement getUpdatedNotes
    return null;
  }
}
