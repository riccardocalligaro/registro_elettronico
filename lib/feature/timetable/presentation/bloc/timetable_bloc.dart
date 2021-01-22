import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';

part 'timetable_event.dart';
part 'timetable_state.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableRepository timetableRepository;
  final SubjectsLocalDatasource subjectsLocalDatasource;

  TimetableBloc({
    @required this.timetableRepository,
    @required this.subjectsLocalDatasource,
  }) : super(TimetableInitial());

  @override
  Stream<TimetableState> mapEventToState(
    TimetableEvent event,
  ) async* {
    if (event is GetTimetable) {
      yield TimetableLoading();
      try {
        final timetable = await timetableRepository.getTimetable();
        final subjects = await subjectsLocalDatasource.getAllSubjects();

        final domainSubjects = subjects
            .map((e) =>
                SubjectDomainModel.fromLocalModel(professors: null, l: e))
            .toList();

        Logger.info('BloC -> Got ${subjects.length} subjects');
        Logger.info('BloC -> Got ${timetable.length} timetable entries');

        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: domainSubjects,
        );
      } on Exception catch (e, s) {
        Logger.e(
          text: 'Error getting timetable',
          exception: e,
          stacktrace: s,
        );
        await FirebaseCrashlytics.instance.recordError(e, s);
        yield TimetableError(e.toString());
      }
    }

    if (event is GetNewTimetable) {
      yield TimetableLoading();
      try {
        await timetableRepository.updateTimeTable();
        final subjects = await subjectsLocalDatasource.getAllSubjects();

        final domainSubjects = subjects
            .map((e) =>
                SubjectDomainModel.fromLocalModel(professors: null, l: e))
            .toList();
        final timetable = await timetableRepository.getTimetable();

        Logger.info('BloC -> Got ${subjects.length} subjects');
        Logger.info('BloC -> Got ${timetable.length} timetable entries');

        yield TimetableLoaded(
          timetableEntries: timetable,
          subjects: domainSubjects,
        );
      } on Exception catch (e, s) {
        Logger.e(
          text: 'Error getting new timetable',
          exception: e,
          stacktrace: s,
        );
        await FirebaseCrashlytics.instance.recordError(e, s);
        yield TimetableError(e.toString());
      }
    }
  }
}
