import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/utils/date_utils.dart';

import 'lesson_remote_model.dart';

///"evtId": 7096829,
///"evtDate": "2019-12-09",
///"evtCode": "LSS0",
///"evtHPos": 1,
///"evtDuration": 1,
///"classDesc": "4IA INFORMATICA",
///"authorName": "TRENTO PAOLO",
///"subjectId": 5,
///"subjectCode": "SOST",
///"subjectDesc": "SOSTEGNO",
///"lessonType": "Compresenza",
///"lessonArg": ""

class LessonMapper {
  static db.Lesson mapLessonEntityToLessoneInsertable(LessonRemoteModel e) {
    return db.Lesson(
      eventId: e.evtId ?? -1,
      date: DateUtils.getDateFromApiString(e.evtDate) ?? DateTime.now(),
      code: e.evtCode ?? "",
      position: e.evtHPos ?? -1,
      duration: e.evtDuration ?? -1,
      classe: e.classDesc ?? "",
      author: e.authorName ?? "",
      subjectId: e.subjectId ?? -1,
      subjectCode: e.subjectCode ?? "",
      subjectDescription: e.subjectDesc ?? "",
      lessonType: e.lessonType ?? "",
      lessonArg: e.lessonArg ?? "",
    );
  }
}
