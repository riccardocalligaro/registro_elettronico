import 'package:registro_elettronico/domain/entity/lesson.dart';

abstract class LessonsRepository {
  Future<List<Lesson>> getLessons(String studentId);
}
