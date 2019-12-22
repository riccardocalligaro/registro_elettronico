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
    lessons.lessons.forEach((lesson) {
      lessonDao.insertLesson(
        lessonMapper.mapLessonEntityToLessoneInsertable(lesson),
      );
    });
  }

  @override
  Future<List<Lesson>> getDateLessons(DateTime date) {
    return lessonDao.getDateLessons(date);
  }

  @override
  Future deleteLessons() {
    return lessonDao.deleteLessons();
  }

  @override
  Stream<List<Lesson>> watchRelevantLessons() {
    return lessonDao.watchRelevantLessons();
  }

  @override
  Stream<List<Lesson>> watchRelevantLessonsOfToday(DateTime today) {
    return lessonDao.watchRelevantLessonsOfToday(today);
  }

  @override
  Stream<List<Lesson>> watchLessonsOrdered() {
    return lessonDao.watchLessonsOrdered();
  }

  @override
  Stream<List<Lesson>> watchLessonsByDate(DateTime date) {
    return lessonDao.watchLessonsByDate(date);
  }

  @override
  Stream<List<Lesson>> watchLastLessons(DateTime date2) {
    return lessonDao.watchLastLessons(date2);
  }

  @override
  Future<List<Lesson>> getLessons() {
    return lessonDao.getLessons();
  }

  @override
  Stream<List<Lesson>> watchLessons() {
    return lessonDao.watchLessons();
  }

  @override
  Future insertLesson(Lesson lesson) {
    return lessonDao.insertLesson(lesson);
  }

  @override
  Future insertLessons(List<Lesson> lessonsToInsert) {
    return lessonDao.insertLessons(lessonsToInsert);
  }
}
