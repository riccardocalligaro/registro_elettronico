import 'dart:async';

import 'package:bloc/bloc.dart';
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

  Stream<List<Grade>> watchAllGrades() => gradesRepository.watchAllGrades();

  Stream<List<Grade>> watchAllGradesOrdered() =>
      gradesRepository.watchAllGradesOrdered();

  Stream<List<Grade>> watchNumberOfGradesByDate() =>
      gradesRepository.watchLastGrades();

  @override
  Stream<GradesState> mapEventToState(
    GradesEvent event,
  ) async* {
    if (event is FetchGrades) {
      yield GradesUpdateLoading();
      await gradesRepository.updateGrades();
      yield GradesUpdateLoaded();
    }

    if (event is GetGrades) {
      //yield GradesLoading();
      final grades = await gradesRepository.getAllGradesOrdered();
      yield GradesLoaded(grades);
    }

    if (event is GetGradesAndSubjects) {
      //yield GradesAndSubjectsLoading();
      final grades = await gradesRepository.getAllGrades();
      final subjects = await subjectsRepository.getAllSubjects();
      yield GradesAndSubjectsLoaded(grades: grades, subject: subjects);
    }

    if (event is UpdateGrade) {
      await gradesRepository.updateGrade(event.grade);
      print("updated");
      final grades = await gradesRepository.getAllGradesOrdered();
      yield GradesLoaded(grades);
    }
  }
}
