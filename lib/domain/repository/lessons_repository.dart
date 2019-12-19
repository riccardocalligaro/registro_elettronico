import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class LessonsRepository {
  // Future<List<Lesson>> getLessons(String studentId);
  ///Get the lessons for a date
  Future<List<Lesson>> getDateLessons(DateTime date);

  ///Delete all lessons
  Future deleteLessons();

  ///Gets only the lessons that are not 'sostegno'
  Stream<List<Lesson>> watchRelevantLessons();

  /// Gets the lesson ignoring sostegno
  Stream<List<Lesson>> watchRelevantLessonsOfToday(DateTime today);

  /// Gets the lessons ordering by a date
  Stream<List<Lesson>> watchLessonsOrdered();

  ///Gets the lessons by a date
  Stream<List<Lesson>> watchLessonsByDate(DateTime date);

  ///Gets the last lessons from a date
  Stream<List<Lesson>> watchLastLessons(DateTime date2);

  /// Future of all the lessons
  Future<List<Lesson>> getLessons();

  // Stream all the lessons
  Stream<List<Lesson>> watchLessons();

  /// Inserts a single lesson
  Future insertLesson(Lesson lesson);

  /// Inserts a list of lessons
  Future insertLessons(List<Lesson> lessonsToInsert);

  Future upadateTodayLessons(String studentId);
  Future updateAllLessons(String studentId);
}
