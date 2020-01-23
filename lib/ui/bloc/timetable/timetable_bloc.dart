import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';

import './bloc.dart';
import '../../../domain/repository/repositories_export.dart';

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
      yield TimetableLoading();
      try {
        final timetable = await timetableRepository.getTimetable();
        final subjects = await subjectsRepository.getAllSubjects();

        FLog.info(text: 'BloC -> Got ${subjects.length} subjects');
        FLog.info(text: 'BloC -> Got ${timetable.length} timetable entries');

        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: subjects,
        );
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting timetable',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);
        yield TimetableError(e.toString());
      }
    }

    if (event is GetNewTimetable) {
      yield TimetableLoading();
      try {
        await timetableRepository.updateTimeTable();
        final subjects = await subjectsRepository.getAllSubjects();
        final timetable = await timetableRepository.getTimetable();

        FLog.info(text: 'BloC -> Got ${subjects.length} subjects');
        FLog.info(text: 'BloC -> Got ${timetable.length} timetable entries');

        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: subjects,
        );
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting new timetable',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);
        yield TimetableError(e.toString());
      }
    }
  }
}
