import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';

import '../../../domain/repository/repositories_export.dart';
import './bloc.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableRepository timetableRepository;
  SubjectsRepository subjectsRepository;

  TimetableBloc(this.timetableRepository, this.subjectsRepository);

  @override
  TimetableState get initialState => TimetableInitial();

  @override
  Stream<TimetableState> mapEventToState(
    TimetableEvent event,
  ) async* {
    if (event is GetTimetable) {
      Logger log = Logger();
      yield TimetableLoading();
      try {
        final timetable = await timetableRepository.getTimetable();
        log.i(timetable.length);
        final subjects = await subjectsRepository.getAllSubjects();
        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: subjects,
        );
      } catch (e) {
        yield TimetableError(e.toString());
      }
    }

    if (event is GetNewTimetable) {
      yield TimetableLoading();
      try {
        Logger log = Logger();

        await timetableRepository.updateTimeTable(event.begin, event.end);
        final subjects = await subjectsRepository.getAllSubjects();
        final timetable = await timetableRepository.getTimetable();
        log.i(timetable.length);

        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: subjects,
        );
      } catch (e) {
        yield TimetableError(e.toString());
      }
    }
  }
}
