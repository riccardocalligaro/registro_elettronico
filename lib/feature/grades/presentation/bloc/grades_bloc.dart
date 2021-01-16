import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'grades_event.dart';
part 'grades_state.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  final GradesRepository gradesRepository;

  GradesBloc({
    @required this.gradesRepository,
  }) : super(GradesInitial());

  @override
  Stream<GradesState> mapEventToState(
    GradesEvent event,
  ) async* {
    if (event is UpdateGrades) {
      yield* _mapUpdateGradesToState();
    } else if (event is GetGrades) {
      yield* _mapGetGradesToState(event.limit ?? -1, event.ordered ?? false);
    }
  }

  Stream<GradesState> _mapUpdateGradesToState() async* {
    yield GradesUpdateLoading();
    try {
      await gradesRepository.updateGrades();

      yield GradesUpdateLoaded();
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield GradesError(message: e.toString());
    }
  }

  Stream<GradesState> _mapGetGradesToState(int limit, bool ordered) async* {
    try {
      List<Grade> grades = [];
      if (limit > -1) {
        grades = await gradesRepository.getNumberOfGradesByDate(limit);
      } else if (ordered) {
        grades = await gradesRepository.getAllGradesOrdered();
      } else {
        grades = await gradesRepository.getAllGrades();
      }
      Logger.info('BloC -> Got ${grades.length} grades');
      yield GradesLoaded(grades);
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield GradesError(message: e.toString());
    }
  }
}
