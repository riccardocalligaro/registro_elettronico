import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import './bloc.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  GradeDao gradeDao;
  GradesRepository gradesRepository;
  ProfileRepository profileRepository;
  SubjectDao subjectDao;

  GradesBloc(this.gradeDao, this.gradesRepository, this.profileRepository,
      this.subjectDao);
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
      final profile = await profileRepository.getDbProfile();
      await gradesRepository.updateGrades(profile.studentId);
      yield GradesUpdateLoaded();
    }

    if (event is GetGrades) {
      yield GradesLoading();
      final grades = await gradeDao.getAllGradesOrdered();
      yield GradesLoaded(grades);
    }

    if (event is GetGradesAndSubjects) {
      yield GradesAndSubjectsLoading();
      final grades = await gradeDao.getAllGrades();
      final subjects = await subjectDao.getAllSubjects();

      yield GradesAndSubjectsLoaded(grades: grades, subject: subjects);
    }
  }
}
