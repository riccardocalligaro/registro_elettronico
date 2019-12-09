import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';

part 'lesson_dao.g.dart';

@UseDao(tables: [Lessons])
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  AppDatabase db;
  LessonDao(this.db) : super(db);

  /// Inserts a single lesson
  Future insertLesson(Insertable<Lesson> lesson) =>
      into(lessons).insert(lesson);

  /// Inserts a list of lessons
  Future insertLessons(List<Insertable<Lesson>> lessonsToInsert) =>
      into(lessons).insertAll(lessonsToInsert);

  /// Get the lessons for a date
  Future<List<Insertable<Lesson>>> getDateLessons(DateTime date) =>
      (select(lessons)..where((lesson) => lesson.date.equals(date))).get();

  Future deleteLessons() => (delete(lessons)
        ..where((entry) => entry.eventId.isBiggerOrEqualValue(-1)))
      .go();

  /// GET - Stream & Future
  Future<List<Insertable<Lesson>>> getLessons() => select(lessons).get();
  Stream<List<Insertable<Lesson>>> watchLessons() => select(lessons).watch();
}
