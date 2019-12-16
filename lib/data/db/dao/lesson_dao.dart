import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/utils/constants/registro_costants.dart';

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
        ..orderBy([
          (lesson) =>
              OrderingTerm(expression: lesson.date, mode: OrderingMode.desc)
        ]))
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

  Stream<List<Lesson>> watchLastLessons(DateTime date) {
    return customSelectQuery("""
        SELECT * FROM lessons 
        WHERE (CAST(strftime("%Y", date, "unixepoch") AS INTEGER) = ?) 
        AND ((CAST(strftime("%m", date, "unixepoch") AS INTEGER) = ?) 
        AND (CAST(strftime("%d", date, "unixepoch") AS INTEGER) = ?)) 
        GROUP BY subject_id ORDER BY position ASC""", readsFrom: {
      lessons
    }, variables: [
      Variable.withInt(date.year),
      Variable.withInt(date.month),
      Variable.withInt(date.day - 1)
    ]).watch().map((rows) {
      return rows.map((row) => Lesson.fromData(row.data, db)).toList();
    });
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
