import 'dart:async';
import 'package:bloc/bloc.dart';
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
      yield NotesUpdateLoading();
      try {
        await notesRepository.updateNotes();
      } catch (e) {
        yield NotesUpdateError(e.toString());
      }
      yield NotesUpdateLoaded();
    }

    if (event is GetNotes) {
      yield NotesLoading();
      try {
        final notes = await notesRepository.getAllNotes();
        yield NotesLoaded(notes);
      } catch (e) {
        yield NotesError(e.toString());
      }
    }
  }
}
