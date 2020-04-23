import 'package:flutter/services.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/utils/entity/genius_timetable.dart';

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
  Future insertTimetableEntries(List<TimetableEntry> entries) async {
    return timetableDao.insertTimetableEntries(entries);
  }

  @override
  Future insertTimetableEntry(TimetableEntry entry) async {
    return timetableDao.insertTimetableEntry(entry);
  }

  @override
  Future updateTimetableEntry(TimetableEntry entry) {
    return timetableDao.updateTimetableEntry(entry);
  }

  @override
  Future updateTimeTable() async {
    timetableDao.deleteTimetable();
    List<GeniusTimetable> genius = await lessonDao.getGeniusTimetable();
    await timetableDao.deleteTimetable();

    return genius.forEach((t) {
      timetableDao.insertTimetableEntry(TimetableEntry(
          start: t.start,
          end: t.end,
          dayOfWeek: int.parse(t.dayOfWeek),
          id: null,
          subject: t.subject,
          subjectName: t.subjectName));
    });
  }

  @override
  Future deleteTimetableEntry(TimetableEntry entry) async {
    return timetableDao.deleteTimetableEntry(entry);
  }

  @override
  Future deleteTimetableEntryWithDate(int dayOfWeek, int begin, int end) async {
    return timetableDao.deleteTimetableEntryWithInfo(dayOfWeek, begin, end);
  }
}
