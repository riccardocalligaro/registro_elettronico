import 'package:logger/logger.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';
import 'package:registro_elettronico/domain/entity/genius_timetable.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

part 'lesson_dao.g.dart';

@UseDao(tables: [
  Lessons,
  Professors,
])
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  AppDatabase db;

  LessonDao(this.db) : super(db);

  /// Get the lessons for a date
  Future<List<Insertable<Lesson>>> getDateLessons(DateTime date) =>
      (select(lessons)..where((lesson) => lesson.date.equals(date))).get();

  Future deleteLessons() => (delete(lessons)
        ..where((entry) => entry.eventId.isBiggerOrEqualValue(-1)))
      .go();

  ///// Gets only the lessons that are not 'sostegno'
  //// Stream<List<Lesson>> watchRelevantLessons() => (select(lessons)
  ////       ..where((lesson) =>
  ////           not(lesson.subjectCode.equals(RegistroConstants.SOSTEGNO)))
  ////       ..orderBy([
  ////         (lesson) =>
  ////             OrderingTerm(expression: lesson.date, mode: OrderingMode.desc)
  ////       ]))
  ////     .watch();

  /// Gets the lesson ignoring sostegno
  Stream<List<Lesson>> watchRelevantLessonsOfToday(DateTime today) =>
      (select(lessons)..where((lesson) =>
          // todo: need to add the date comparing
          not(lesson.subjectCode.equals(RegistroConstants.SOSTEGNO)))).watch();

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

  Stream<List<Lesson>> watchLessonsByDateGrouped(DateTime date) {
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
      Variable.withInt(date.day)
    ]).watch().map((rows) {
      return rows.map((row) => Lesson.fromData(row.data, db)).toList();
    });
  }

  Stream<List<Lesson>> watchLastLessons() {
    return customSelectQuery(
      'SELECT * FROM lessons WHERE date IN (SELECT max(date) FROM lessons)',
      readsFrom: {
        lessons,
      },
    ).watch().map((rows) {
      return rows.map((row) => Lesson.fromData(row.data, db)).toList();
    });
  }

  Stream<List<Lesson>> watchRelevantLessons() {
    return customSelectQuery(
      """ SELECT * FROM lessons GROUP BY lesson_arg, author ORDER BY date DESC""",
      readsFrom: {
        lessons,
      },
    ).watch().map((rows) {
      return rows.map((row) => Lesson.fromData(row.data, db)).toList();
    });
  }

  // @Query("select `dayOfWeek`,`teacher`,`subject`,`start`,`end` from ( select " +
  //           "strftime('%w', M_DATE/1000, 'unixepoch') as `dayOfWeek`, " +
  //           "`TEACHER`.`ID` as `teacher`, " +
  //           "`M_SUBJECT_ID` as `subject`, " +
  //           "M_HOUR_POSITION+7 as `start`, " +
  //           "M_HOUR_POSITION+8 as `end`, " +
  //           "COUNT(M_DURATION) as `totalHours` " +
  //           "from `LESSON` LEFT JOIN `TEACHER` ON `M_AUTHOR_NAME`=`TEACHER_NAME` " +
  //           "where PROFILE = :profile AND M_SUBJECT_CODE!='SUPZ' AND M_DATE>(strftime('%s', 'now', 'localtime') - 45*24*3600)*1000 " +
  //           "group by `dayOfWeek`,M_HOUR_POSITION, M_SUBJECT_CODE " +
  //           "order by `dayOfWeek`, M_HOUR_POSITION  asc) where `totalHours`>1 " +
  //           "group by `dayOfWeek`, `start`")

  Future<List<GeniusTimetable>> getGeniusTimetable() {
    Logger logger = Logger();
    return customSelectQuery(
      """ SELECT `dayOfWeek`,`teacher`,`subject`,`start`,`end` FROM
      (select strftime('%w', date/1000, 'unixepoch') as `dayOfWeek`,
      `subject_id` as `subject`,
      (position+8) as `start`,
      (position+9) as `end`,
      author as `teacher`,
      COUNT(duration) as `totalHours`
      FROM `lessons`
      WHERE subject_code NOT IN ('SUPZ', 'SOST') AND date>(strftime('%s', 'now', 'localtime') - 45*24*3600)*1000
      GROUP BY `dayOfWeek`, position, subject_code
      ORDER BY `dayOfWeek`, position ASC) WHERE `totalHours`>1
      GROUP BY `dayOfWeek`, `start`
      """,
      readsFrom: {
        lessons,
        professors,
      },
    ).map((row) {
      logger.i(row.data);
      return GeniusTimetable.fromData(row.data, db);
    }).get();
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
