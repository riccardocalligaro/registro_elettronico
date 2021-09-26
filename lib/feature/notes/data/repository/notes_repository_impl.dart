import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/notes/data/model/note_mapper.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NoteDao? noteDao;
  final LegacySpaggiariClient? spaggiariClient;
  final ProfilesLocalDatasource? profilesLocalDatasource;
  final NetworkInfo? networkInfo;
  final AuthenticationRepository? authenticationRepository;

  NotesRepositoryImpl(
    this.noteDao,
    this.spaggiariClient,
    this.profilesLocalDatasource,
    this.networkInfo,
    this.authenticationRepository,
  );

  @override
  Future deleteAllNotes() {
    return noteDao!.deleteAllNotes();
  }

  @override
  Future<List<Note>> getAllNotes() {
    return noteDao!.getAllNotes();
  }

  @override
  Future insertNote(Note note) {
    return noteDao!.insertNote(note);
  }

  @override
  Future updateNotes() async {
    if (await networkInfo!.isConnected) {
      final studentId = await (authenticationRepository!.getCurrentStudentId() as FutureOr<String>);

      final notesResponse = await spaggiariClient!.getNotes(studentId);

      List<Note> notes = [];
      notesResponse.notesNTCL!.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTCL')));
      notesResponse.notesNTWN!.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTWN')));
      notesResponse.notesNTTE!.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTTE')));
      notesResponse.notesNTST!.forEach((note) =>
          notes.add(NoteMapper.convertNotetEntityToInsertable(note, 'NTST')));

      Logger.info(
        'Got ${notesResponse.notesNTCL!.length} notesNTCL from server, procceding to insert in database',
      );
      Logger.info(
        'Got ${notesResponse.notesNTWN!.length} notesNTWN from server, procceding to insert in database',
      );
      Logger.info(
        'Got ${notesResponse.notesNTTE!.length} notesNTTE from server, procceding to insert in database',
      );
      Logger.info(
        'Got ${notesResponse.notesNTST!.length} notesNTST from server, procceding to insert in database',
      );
      await noteDao!.deleteAllAttachments();
      await noteDao!.deleteAllNotes();

      await noteDao!.insertNotes(notes);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<NotesReadResponse> readNote(String type, int eventId) async {
    if (await networkInfo!.isConnected) {
      final studentId = await (authenticationRepository!.getCurrentStudentId() as FutureOr<String>);

      final res = await spaggiariClient!.markNote(studentId, type, eventId, "");
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future deleteAllAttachments() {
    return noteDao!.deleteAllAttachments();
  }

  @override
  Future<NotesAttachment> getAttachmentForNote(String? type, int? eventId) async {
    if (await networkInfo!.isConnected) {
      final studentId = await authenticationRepository!.getCurrentStudentId();
      final attachments = await noteDao!.getAllAttachments();

      for (var attachment in attachments) {
        if (attachment.id == eventId) return attachment;
      }

      final res = await spaggiariClient!.markNote(studentId!, type!, eventId!, "");
      final insertable =
          NoteMapper.convertNoteAttachmentResponseToInsertable(res);

      await noteDao!.deleteAllAttachments();
      await noteDao!.insertAttachment(insertable);

      return insertable;
    } else {
      throw NotConntectedException();
    }
  }
}
