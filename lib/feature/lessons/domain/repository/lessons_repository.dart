import 'package:registro_elettronico/core/data/local/moor_database.dart';

abstract class LessonsRepository {
  /// Updates the lessons only for the [current] day
  Future upadateTodayLessons();

  /// Updates [all] the lessons
  Future updateAllLessons();

  /// Gets the [last] lessons of the [last day] where there are lessons
  /// It ignores [sostegno]
  Future<List<Lesson>> getLastLessons();

  /// Gets lessons of a [date] by checking the day, month and year
  Future<List<Lesson>> getLessonsByDate(DateTime date);

  /// Gets of [all] the lessons
  Future<List<Lesson>> getLessons();

  /// Gets lessons for a [subject]
  Future<List<Lesson>> getLessonsForSubject(int subjectId);

  ///Delete all lessons
  Future deleteAllLessons();

  /// Inserts a single lesson
  Future insertLesson(Lesson lesson);

  /// Inserts a list of lessons
  Future insertLessons(List<Lesson> lessonsToInsert);
}
