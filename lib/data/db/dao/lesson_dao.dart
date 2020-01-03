import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';

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

  ////Stream<List<Lesson>> watchLessonsOrdered() {
  ////  return (select(lessons)..orderBy([(t) => OrderingTerm(expression: t.date)]))
  ////      .watch();
  ////}
////
  ////Stream<List<Lesson>> watchLessonsByDate(DateTime date) {
  ////  return (select(lessons)
  ////        ..where((row) {
  ////          final endDate = row.date;
  ////          final sameYear = year(endDate).equals(date.year);
  ////          final sameMonth = month(endDate).equals(date.month);
  ////          final sameDay = day(endDate).equals(date.day - 1);
  ////          return and(sameYear, and(sameMonth, sameDay));
  ////        }))
  ////      .watch();
  ////}
////
  ////Stream<List<Lesson>> watchLessonsByDateGrouped(DateTime date) {
  ////  return customSelectQuery("""
  ////      SELECT * FROM lessons
  ////      WHERE (CAST(strftime("%Y", date, "unixepoch") AS INTEGER) = ?)
  ////      AND ((CAST(strftime("%m", date, "unixepoch") AS INTEGER) = ?)
  ////      AND (CAST(strftime("%d", date, "unixepoch") AS INTEGER) = ?))
  ////      GROUP BY subject_id ORDER BY position ASC""", readsFrom: {
  ////    lessons
  ////  }, variables: [
  ////    Variable.withInt(date.year),
  ////    Variable.withInt(date.month),
  ////    Variable.withInt(date.day)
  ////  ]).watch().map((rows) {
  ////    return rows.map((row) => Lesson.fromData(row.data, db)).toList();
  ////  });
  ////}

  ////Stream<List<Lesson>> watchLastLessons() {
  ////  return customSelectQuery(
  ////    'SELECT * FROM lessons WHERE date IN (SELECT max(date) FROM lessons)',
  ////    readsFrom: {
  ////      lessons,
  ////    },
  ////  ).watch().map((rows) {
  ////    return rows.map((row) => Lesson.fromData(row.data, db)).toList();
  ////  });
  ////}

  ////Stream<List<Lesson>> watchRelevantLessons() {
  ////  return customSelectQuery(
  ////    """ SELECT * FROM lessons GROUP BY lesson_arg, author ORDER BY date DESC""",
  ////    readsFrom: {
  ////      lessons,
  ////    },
  ////  ).watch().map((rows) {
  ////    return rows.map((row) => Lesson.fromData(row.data, db)).toList();
  ////  });
  ////}

  // Future<List<Lesson>> getLessonsBetweenDates(DateTime begin, DateTime end) {
  //   return customSelectQuery(
  //     'SELECT * FROM lessons WHERE date > ? AND date < ?',
  //     variables: [
  //       Variable.withDateTime(begin),
  //       Variable.withDateTime(end)
  //     ]
  //   )
  //   .map((row) {
  //     return Lesson.fromData(row.data, db);
  //   }).get();
  // }

  ////Future<List<GeniusTimetable>> getGeniusTimetable() {
  ////  Logger logger = Logger();
  ////  return customSelectQuery(
  ////    """ SELECT `dayOfWeek`,`teacher`,`subject`,`start`,`end` FROM
  ////    (select strftime('%w', date/1000, 'unixepoch') as `dayOfWeek`,
  ////    `subject_id` as `subject`,
  ////    (position+8) as `start`,
  ////    (position+9) as `end`,
  ////    author as `teacher`,
  ////    COUNT(duration) as `totalHours`
  ////    FROM `lessons`
  ////    WHERE subject_code NOT IN ('SUPZ', 'SOST') AND date>(strftime('%s', 'now', 'localtime') - 45*24*3600)*1000
  ////    GROUP BY `dayOfWeek`, position, subject_code
  ////    ORDER BY `dayOfWeek`, position ASC) WHERE `totalHours`>1
  ////    GROUP BY `dayOfWeek`, `start`
  ////    """,
  ////    readsFrom: {
  ////      lessons,
  ////      professors,
  ////    },
  ////  ).map((row) {
  ////    logger.i(row.data);
  ////    return GeniusTimetable.fromData(row.data, db);
  ////  }).get();
  ////}

  ////// Stream all the lessons
  ////Stream<List<Lesson>> watchLessons() => select(lessons).watch();

}
