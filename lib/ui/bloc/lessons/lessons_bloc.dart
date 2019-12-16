import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import './bloc.dart';

class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  ProfileRepository profileRepository;
  LessonsRepository lessonsRepository;
  LessonDao lessonDao;

  LessonsBloc(this.lessonDao, this.lessonsRepository, this.profileRepository);

  Stream<List<Lesson>> get relevantLessons => lessonDao.watchRelevantLessons();
  //Stream<List<Lesson>> get relevandLessonsOfToday =>
  //    lessonDao.watchLessonsByDate(DateTime.now());

  Stream<List<Lesson>> get relevandLessonsOfToday =>
      lessonDao.watchLastLessons(DateTime.now());

  @override
  LessonsState get initialState => LessonsNotLoaded();

  @override
  Stream<LessonsState> mapEventToState(
    LessonsEvent event,
  ) async* {
    if (event is FetchTodayLessons) {
      yield LessonsLoading();
      try {
        final profile = await profileRepository.getDbProfile();
        await lessonsRepository
            .upadateTodayLessons(profile.studentId.toString());

        yield LessonsLoaded();
      } on DioError catch (e) {
        yield LessonsError(e);
      }
    }

    if (event is FetchAllLessons) {
      yield LessonsLoading();
      try {
        final profile = await profileRepository.getDbProfile();
        await lessonsRepository.updateAllLessons(profile.studentId.toString());

        yield LessonsLoaded();
      } on DioError catch (e) {
        yield LessonsError(e);
      }
    }
  }
}
