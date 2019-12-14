abstract class LessonsRepository {
  // Future<List<Lesson>> getLessons(String studentId);

  Future upadateTodayLessons(String studentId);

  Future updateAllLessons(String studentId);
}
