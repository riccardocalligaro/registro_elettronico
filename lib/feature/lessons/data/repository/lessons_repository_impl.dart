import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/lessons/data/dao/lesson_dao.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

import '../model/lesson_mapper.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  SpaggiariClient spaggiariClient;
  LessonDao lessonDao;
  ProfileDao profileDao;
  NetworkInfo networkInfo;

  LessonsRepositoryImpl(
    this.spaggiariClient,
    this.lessonDao,
    this.profileDao,
    this.networkInfo,
  );

  @override
  Future upadateTodayLessons() async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();
      final lessons = await spaggiariClient.getTodayLessons(profile.studentId);

      List<Lesson> lessonsList = [];
      lessons.lessons.forEach((lesson) {
        lessonsList
            .add(LessonMapper.mapLessonEntityToLessoneInsertable(lesson));
      });

      FLog.info(
        text:
            'Got ${lessons.lessons.length} documents from server, procceding to insert in database',
      );

      lessonDao.insertLessons(lessonsList);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future updateAllLessons() async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();
      final dateInterval = DateUtils.getDateInerval();
      final lessons = await spaggiariClient.getLessonBetweenDates(
        profile.studentId,
        dateInterval.begin,
        dateInterval.end,
      );
      List<Lesson> lessonsInsertable = [];
      lessons.lessons.forEach((lesson) {
        lessonsInsertable
            .add(LessonMapper.mapLessonEntityToLessoneInsertable(lesson));
      });
      await lessonDao.deleteLessons();

      lessonDao.insertLessons(lessonsInsertable);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<List<Lesson>> getLessons() {
    return lessonDao.getLessons();
  }

  @override
  Future insertLesson(Lesson lesson) {
    return lessonDao.insertLesson(lesson);
  }

  @override
  Future insertLessons(List<Lesson> lessonsToInsert) {
    return lessonDao.insertLessons(lessonsToInsert);
  }

  @override
  Future deleteAllLessons() {
    return lessonDao.deleteLessons();
  }

  @override
  Future<List<Lesson>> getLastLessons() {
    return lessonDao.getLastLessons();
  }

  @override
  Future<List<Lesson>> getLessonsByDate(DateTime date) {
    return lessonDao.getLessonsByDate(date);
  }

  @override
  Future<List<Lesson>> getLessonsForSubject(int subjectId) {
    return lessonDao.getLessonsForSubjectId(subjectId);
  }
}
