import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/domain/entity/lesson.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  SpaggiariClient spaggiariClient;

  LessonsRepositoryImpl(this.spaggiariClient);
  @override
  Future<List<Lesson>> getLessons(String studentId) async {
    final lessons = await spaggiariClient.getTodayLessons(studentId);
    //final lessonsList = lesson
    // return lessons;
    //return lessons;
  }
}
