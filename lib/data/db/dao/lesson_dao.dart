import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';
import 'package:registro_elettronico/utils/entity/genius_timetable.dart';

part 'lesson_dao.g.dart';

@UseDao(tables: [
  Lessons,
  Professors,
])
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  AppDatabase db;

  LessonDao(this.db) : super(db);

  /// Gets the [last] lessons of the [last day] where there are lessons
  /// It ignores [sostegno]
  Future<List<Lesson>> getLastLessons() {
    return customSelectQuery(
      'SELECT * FROM lessons WHERE date IN (SELECT max(date) FROM lessons) AND subject_code != "SOST"',
      readsFrom: {
        lessons,
      },
    ).map((row) {
      return Lesson.fromData(row.data, db);
    }).get();
  }

  Future<List<Lesson>> getLessonsForSubjectId(int subjectId) {
    return customSelectQuery(
      'SELECT * FROM lessons WHERE subject_id = ? GROUP BY lesson_arg ORDER BY date DESC',
      readsFrom: {
        lessons,
      },
      variables: [
        Variable.withInt(subjectId),
      ],
    ).map((row) {
      return Lesson.fromData(row.data, db);
    }).get();
  }

  /// Gets lessons of a [date] by checking the day, month and year
  Future<List<Lesson>> getLessonsByDate(DateTime date) {
    return customSelectQuery("""
        SELECT * FROM lessons 
        WHERE (CAST(strftime("%Y", date, "unixepoch") AS INTEGER) = ?) 
        AND ((CAST(strftime("%m", date, "unixepoch") AS INTEGER) = ?) 
        AND (CAST(strftime("%d", date, "unixepoch") AS INTEGER) = ?)) 
        AND subject_code != 'SOST'
        GROUP BY lesson_arg, author ORDER BY position ASC""", readsFrom: {
      lessons
    }, variables: [
      Variable.withInt(date.year),
      Variable.withInt(date.month),
      Variable.withInt(date.day)
    ]).map((row) {
      return Lesson.fromData(row.data, db);
    }).get();
  }

  /// Gets lessons between [begin] and [end], it ignores [sostegno] and [supplenza]
  /// This function is used for generating the timetable
  Future<List<Lesson>> getLessonsBetweenDates(DateTime begin, DateTime end) {
    return customSelectQuery(
        'SELECT * FROM lessons WHERE date >= ? AND date <= ? AND subject_code NOT IN("SOST", "SUPZ") GROUP BY subject_id,date, position',
        variables: [
          Variable.withDateTime(begin),
          Variable.withDateTime(end)
        ]).map((row) => Lesson.fromData(row.data, db)).get();
  }

  /// Future of [all] the lessons
  Future<List<Lesson>> getLessons() => select(lessons).get();

  /// Inserts a [single] lesson
  Future insertLesson(Insertable<Lesson> lesson) =>
      into(lessons).insert(lesson, orReplace: true);

  /// Inserts a [list] of lessons
  Future insertLessons(List<Insertable<Lesson>> lessonsToInsert) =>
      into(lessons).insertAll(lessonsToInsert, orReplace: true);

  /// Deletes [all] lessons
  Future deleteLessons() => delete(lessons).go();

  // Thanks to Registro elettronico android by simone luconi
  Future<List<GeniusTimetable>> getGeniusTimetable() {
    return customSelectQuery(""" SELECT `dayOfWeek`,`teacher`,`subject`, `subject_name`,`start`,`end` FROM
      (select strftime('%w', date, 'unixepoch') as `dayOfWeek`,
      `subject_id` as `subject`,
      `subject_description` as `subject_name`,
      (position) as `start`,
      (position) as `end`,
      author as `teacher`,
      COUNT(duration) as `totalHours`
      FROM `lessons`
      WHERE subject_code NOT IN ('SUPZ', 'SOST') AND date>?
      GROUP BY `dayOfWeek`, position, subject_code
      ORDER BY `dayOfWeek`, position ASC) WHERE `totalHours`>1
      GROUP BY `dayOfWeek`, `start`
      """, readsFrom: {
      lessons,
      professors,
    }, variables: [
      Variable.withDateTime(DateTime.now().subtract(Duration(days: 45)))
    ]).map((row) {
      return GeniusTimetable.fromData(row.data, db);
    }).get();
  }
}
