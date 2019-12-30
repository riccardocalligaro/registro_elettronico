import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  TimetableDao timetableDao;
  LessonDao lessonDao;

  TimetableRepositoryImpl(this.timetableDao, this.lessonDao);

  @override
  Future deleteTimetable() {
    return timetableDao.deleteTimetable();
  }

  @override
  Future<List<TimetableEntry>> getTimetable() {
    return timetableDao.getTimetable();
  }

  @override
  Future insertTimetableEntries(List<TimetableEntry> entries) {
    return timetableDao.insertTimetableEntries(entries);
  }

  @override
  Future insertTimetableEntry(TimetableEntry entry) {
    return timetableDao.insertTimetableEntry(entry);
  }

  @override
  Future updateTimetableEntry(TimetableEntry entry) {
    return timetableDao.updateTimetableEntry(entry);
  }

  @override
  Future updateTimeTable(DateTime begin, DateTime end) async {
    final lessons = await lessonDao.getLessonsBetweenDates(begin, end);

    /// We need to clean the lessons and remove [duplicates]
    final groupedLessons = GlobalUtils.getGroupedLessonsList(lessons);

    /// We have the [grouped] lessons, we map them and insert them in the [db]
    timetableDao.insertTimetableEntries(groupedLessons.map((lesson) {
      return TimetableEntry(
        duration: lesson.duration,
        date: lesson.date,
        subject: lesson.subjectDescription,
        position: lesson.position,
        eventId: lesson.eventId,
        author: lesson.author
      );
    }).toList());
  }

  @override
  Future<Map<DateTime, List<TimetableEntry>>> getTimetableMap() async {
    final timetable = await timetableDao.getTimetable()
      ..sort((a, b) => a.date.weekday.compareTo(b.date.weekday));
    final Map<DateTime, List<TimetableEntry>> timetableMap = Map.fromIterable(
      timetable,
      key: (e) => e.date,
      value: (e) => timetable
          .where(
            (entry) =>
                e.date.day == entry.date.day &&
                e.date.month == entry.date.month &&
                e.date.year == entry.date.year,
          )
          .toSet()
          .toList(),
    );
    return timetableMap;
  }
}
