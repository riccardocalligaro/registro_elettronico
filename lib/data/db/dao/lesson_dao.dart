import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/component/registro_costants.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';

part 'lesson_dao.g.dart';

@UseDao(tables: [Lessons])
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  AppDatabase db;

  LessonDao(this.db) : super(db);

  /// Get the lessons for a date
  Future<List<Insertable<Lesson>>> getDateLessons(DateTime date) =>
      (select(lessons)..where((lesson) => lesson.date.equals(date))).get();

  Future deleteLessons() => (delete(lessons)
        ..where((entry) => entry.eventId.isBiggerOrEqualValue(-1)))
      .go();

  /// Gets only the lessons that are not 'sostegno'
  Stream<List<Lesson>> watchRelevantLessons() => (select(lessons)
        ..where((lesson) =>
            not(lesson.subjectCode.equals(RegistroCostants.SOSTEGNO)))
        ..orderBy([(lesson) => OrderingTerm(expression: lesson.position)]))
      .watch();

  /// Gets the lesson ignoring sostegno
  Stream<List<Lesson>> watchRelevantLessonsOfToday(DateTime today) =>
      (select(lessons)..where((lesson) =>
          // todo: need to add the date comparing
          not(lesson.subjectCode.equals(RegistroCostants.SOSTEGNO)))).watch();

  /// Gets the lessons ordering by a date
  Stream<List<Lesson>> watchLessonsOrdered() {
    return (select(lessons)..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .watch();
  }

  Stream<List<Lesson>> watchLessonsByDate(DateTime date) {
    return (select(lessons)
          ..where((row) {
            final endDate = row.date;
            final sameYear = year(endDate).equals(date.year);
            final sameMonth = month(endDate).equals(date.month);
            final sameDay = day(endDate).equals(date.day - 1);
            return and(sameYear, and(sameMonth, sameDay));
          }))
        .watch();
  }

  /// Future of all the lessons
  Future<List<Lesson>> getLessons() => select(lessons).get();

  // Stream all the lessons
  Stream<List<Lesson>> watchLessons() => select(lessons).watch();

  /// Inserts a single lesson
  Future insertLesson(Insertable<Lesson> lesson) =>
      into(lessons).insert(lesson, orReplace: true);

  /// Inserts a list of lessons
  Future insertLessons(List<Insertable<Lesson>> lessonsToInsert) =>
      into(lessons).insertAll(lessonsToInsert);
}
