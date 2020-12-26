import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import './bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesRepository notesRepository;

  NotesBloc(this.notesRepository);

  @override
  NotesState get initialState => NotesInitial();

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    if (event is UpdateNotes) {
      yield* _mapUpdateNotesToState();
    } else if (event is GetNotes) {
      yield* _mapGetNotesToState();
    }
  }

  Stream<NotesState> _mapUpdateNotesToState() async* {
    yield NotesUpdateLoading();
    FLog.info(text: 'Updating notes');
    try {
      await notesRepository.deleteAllNotes();
      await notesRepository.updateNotes();
      FLog.info(text: 'Updated notes');
    } on NotConntectedException {
      yield NotesLoadErrorNotConnected();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield NotesUpdateError(e.toString());
    }
    yield NotesUpdateLoaded();
  }

  Stream<NotesState> _mapGetNotesToState() async* {
    yield NotesLoading();
    try {
      final notes = await notesRepository.getAllNotes();
      FLog.info(text: 'BloC -> Loaded ${notes.length} notes');
      yield NotesLoaded(notes);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error loading notes',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield NotesError(e.toString());
    }
  }
}
