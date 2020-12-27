import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences prefs = sl();
      await gradesRepository.updateGrades();
      prefs.setInt(
        PrefsConstants.LAST_UPDATE_GRADES,
        DateTime.now().millisecondsSinceEpoch,
      );
      yield GradesUpdateLoaded();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
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
      FLog.info(text: 'BloC -> Got ${grades.length} grades');
      yield GradesLoaded(grades);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield GradesError(message: e.toString());
    }
  }
}
