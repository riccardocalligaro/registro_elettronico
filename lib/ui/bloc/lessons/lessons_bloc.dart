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

  Stream<List<Lesson>> get lessons => lessonDao.watchLessonsByDate();

  @override
  LessonsState get initialState => LessonsNotLoaded();

  @override
  Stream<LessonsState> mapEventToState(
    LessonsEvent event,
  ) async* {
    if (event is FetchLessons) {
      yield LessonsLoading();
      try {
        final profile = await profileRepository.getDbProfile();
        await lessonsRepository.upadateLessons(profile.studentId.toString());

        yield LessonsLoaded();
      } on DioError catch (e) {
        print("exception");
        yield LessonsError(e);
      }
    }
  }
}
