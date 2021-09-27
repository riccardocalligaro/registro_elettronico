import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository? notesRepository;

  NotesBloc({
    required this.notesRepository,
  }) : super(NotesInitial());

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
    Fimber.i('Updating notes');
    try {
      await notesRepository!.deleteAllNotes();
      await notesRepository!.updateNotes();
      Fimber.i('Updated notes');
    } on NotConntectedException {
      yield NotesLoadErrorNotConnected();
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield NotesUpdateError(e.toString());
    }
    yield NotesUpdateLoaded();
  }

  Stream<NotesState> _mapGetNotesToState() async* {
    yield NotesLoading();
    try {
      final notes = await notesRepository!.getAllNotes();
      Fimber.i('BloC -> Loaded ${notes.length} notes');
      yield NotesLoaded(notes);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield NotesError(e.toString());
    }
  }
}
