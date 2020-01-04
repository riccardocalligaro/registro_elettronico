import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/utils/entity/genius_timetable.dart';

import '../../utils/global_utils.dart';

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
  Future updateTimeTable() async {
    timetableDao.deleteTimetable();
    List<GeniusTimetable> genius = await lessonDao.getGeniusTimetable();
    await timetableDao.deleteTimetable();

    genius.forEach((t) {
      timetableDao.insertTimetableEntry(TimetableEntry(
        start: t.start,
        end: t.end,
        dayOfWeek: int.parse(t.dayOfWeek),
        id: null,
        subject: t.subject,
      ));
    });
  }

  // final Map<int, List<GeniusTimetable>> timetableMap = Map.fromIterable(
  //     genius,
  //     key: (e) => int.parse(e.dayOfWeek),
  //     value: (e) => genius);

  // timetableMap.keys.forEach((key) {
  //   List<GeniusTimetable> today = timetableMap[key];
  //   today.sort((a, b) => a.start.compareTo(b.start));

  //   for (var i = 0; i < today.length - 1; i++) {
  //     if (today[i].subject == today[i + 1].subject) {
  //       for (var j = 0; j < today.length - 1; j++) {
  //         if (today[j].subject != today[j + 1].subject) continue;
  //         var temp = today[i];
  //         temp.end = today[i + 1].end;
  //         today.removeAt(i + 1);
  //         today[i] = temp;
  //         break;
  //       }
  //     }
  //   }

  //   today.forEach((t) {
  //     timetableDao.insertTimetableEntry(TimetableEntry(
  //       start: t.start,
  //       end: t.end,
  //       dayOfWeek: int.parse(t.dayOfWeek),
  //       id: null,
  //       subject: t.subject,
  //     ));
  //   });

  // //Per ogni giorno della settimana
  // genius.groupBy { it.dayOfWeek }.entries.forEach { entry: Map.Entry<Int, List<GeniusTimetable>> ->
  //     Log.d("Day ${entry.key}", "ENTRY")
  //     val today = entry.value.sortedBy { it.start }.toMutableList()

  //     //finchè ci sono duplicati
  //     while ((0 until today.size - 1).any { today[it].subject == today[it + 1].subject }) {
  //         Log.d("Day ${entry.key}", "duplicates: ${(0 until today.size - 1).any { today[it].subject == today[it + 1].subject }}")

  //         //controlla da cima a fondo e rimuovi un duplicato. Ripeti
  //         for (i in 0 until today.size - 1) {
  //             if (today[i].subject != today[i + 1].subject) continue

  //             val temp = today[i]
  //             temp.end = today[i + 1].end
  //             today.removeAt(i + 1)
  //             today[i] = temp
  //             Log.d("Day ${entry.key}", "Deleted duplicate, now range: ${temp.start}-${temp.end}")

  //             //chiudi loop per sicurezza, ripeti aggiornando today.size
  //             break
  //         }
  //     }

  //     today.forEach {
  //         timetable.add(TimetableItem(
  //                 0,
  //                 profile.toInt(),
  //                 it.start.toFloat(),
  //                 it.end.toFloat(),
  //                 it.dayOfWeek,
  //                 it.subject.toLong(),
  //                 subjectColors[it.subject]?.toInt()
  //                         ?: throw IllegalStateException("Color not found in Map"),
  //                 null, null
  //         ))
  //     }
}

// @override
// Future<Map<DateTime, List<TimetableEntry>>> getTimetableMap() async {
//   final timetable = await timetableDao.getTimetable()
//     ..sort((a, b) => a.date.weekday.compareTo(b.date.weekday));
//   final Map<DateTime, List<TimetableEntry>> timetableMap = Map.fromIterable(
//     timetable,
//     key: (e) => e.date,
//     value: (e) => timetable
//         .where(
//           (entry) =>
//               e.date.day == entry.date.day &&
//               e.date.month == entry.date.month &&
//               e.date.year == entry.date.year,
//         )
//         .toSet()
//         .toList(),
//   );
//   return timetableMap;
// }
