import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

import 'mapper/lesson_mapper.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  LessonMapper lessonMapper;
  SpaggiariClient spaggiariClient;
  LessonDao lessonDao;
  ProfileDao profileDao;
  NetworkInfo networkInfo;

  LessonsRepositoryImpl(
    this.spaggiariClient,
    this.lessonMapper,
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
            .add(lessonMapper.mapLessonEntityToLessoneInsertable(lesson));
      });

      FLog.info(
        text:
            'Got ${lessons.lessons.length} documents from server, procceding to insert in database',
      );

      lessonDao.insertLessons(lessonsList);
    } else {
      throw new NotConntectedException();
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
            .add(lessonMapper.mapLessonEntityToLessoneInsertable(lesson));
      });
      await lessonDao.deleteLessons();

      lessonDao.insertLessons(lessonsInsertable);
    } else {
      throw new NotConntectedException();
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
