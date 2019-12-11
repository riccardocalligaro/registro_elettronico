import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';

import 'mapper/lesson_mapper.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  LessonMapper lessonMapper;
  SpaggiariClient spaggiariClient;
  LessonDao lessonDao;

  LessonsRepositoryImpl(
      this.spaggiariClient, this.lessonMapper, this.lessonDao);

  @override
  Future upadateLessons(String studentId) async {
    final lessons = await spaggiariClient.getTodayLessons(studentId);
    lessons.lessons.forEach((lesson) {
      lessonDao.insertLesson(
          lessonMapper.mapLessonEntityToLessoneInsertable(lesson));
    });
  }
}
