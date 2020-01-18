import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  GradesRepository gradesRepository;

  SubjectsRepository subjectsRepository;

  GradesBloc(this.gradesRepository, this.subjectsRepository);
  @override
  GradesState get initialState => GradesInitial();

  @override
  Stream<GradesState> mapEventToState(
    GradesEvent event,
  ) async* {
    if (event is UpdateGrades) {
      yield* _mapUpdateGradesToState();
    } else if (event is GetGrades) {
      yield* _mapGetGradesToState(event.limit ?? -1, event.ordered ?? false);
    } 
    
    // else if (event is ResetGrades) {
    //   yield GradesInitial();
    // }
  }

  Stream<GradesState> _mapUpdateGradesToState() async* {
    yield GradesUpdateLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await gradesRepository.updateGrades();
      prefs.setInt(
        PrefsConstants.LAST_UPDATE_GRADES,
        DateTime.now().millisecondsSinceEpoch,
      );
      yield GradesUpdateLoaded();
    } catch (e, s) {
      Crashlytics.instance.recordError(e, s);
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
      Crashlytics.instance.recordError(e, s);
      yield GradesError(message: e.toString());
    }
  }
}
