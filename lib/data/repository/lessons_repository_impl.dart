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

  LessonsRepositoryImpl(
    this.spaggiariClient,
    this.lessonMapper,
    this.lessonDao,
    this.profileDao,
  );

  @override
  Future upadateTodayLessons() async {
    final profile = await profileDao.getProfile();
    final lessons = await spaggiariClient.getTodayLessons(profile.studentId);
    lessons.lessons.forEach((lesson) {
      lessonDao.insertLesson(
          lessonMapper.mapLessonEntityToLessoneInsertable(lesson));
    });
  }

  @override
  Future updateAllLessons() async {
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

    lessonDao.insertLessons(lessonsInsertable);
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
}
