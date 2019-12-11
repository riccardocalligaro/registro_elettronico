import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import './bloc.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  GradeDao gradeDao;
  GradesRepository gradesRepository;
  ProfileRepository profileRepository;

  GradesBloc(this.gradeDao, this.gradesRepository, this.profileRepository);
  @override
  GradesState get initialState => GradesInitial();

  Stream<List<Grade>> watchAllGrades() => gradeDao.watchAllGrades();

  @override
  Stream<GradesState> mapEventToState(
    GradesEvent event,
  ) async* {
    if (event is FetchGrades) {
      yield GradesLoading();
      final profile = await profileRepository.getDbProfile();
      await gradesRepository.updateGrades(profile.studentId);
      yield GradesLoaded();
      // try {
      //   final profile = await profileRepository.getDbProfile();
      //   await gradesRepository.updateGrades(profile.studentId);
      //   yield GradesLoaded();
      // } on DioError catch (e) {
      //   yield GradesError(e.response.data.toString());
      // } catch (e) {
      //   yield GradesError(e.toString());
      // }
    }
  }
}
