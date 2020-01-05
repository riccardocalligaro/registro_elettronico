import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';

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
    Logger log = Logger();
    log.i(event.toString());
    if (event is UpdateGrades) {
      yield* _mapUpdateGradesToState();
    } else if (event is GetGrades) {
      yield* _mapGetGradesToState(event.limit ?? -1, event.ordered ?? false);
    }
  }

  Stream<GradesState> _mapUpdateGradesToState() async* {
    yield GradesUpdateLoading();
    try {
      await gradesRepository.deleteAllGrades();
      await gradesRepository.updateGrades();
      yield GradesUpdateLoaded();
    } catch (e) {
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

      yield GradesLoaded(grades);
    } catch (e) {
      yield GradesError(message: e.toString());
    }
  }
}
