import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

void main() {
  group('test lesson group utility', () {
    final lesson = Lesson(
      subjectId: 1,
      lessonArg: "Esercizi",
      date: DateTime.utc(2019, 12, 30),
      lessonType: "Compresenza",
      author: "Mario Rossi",
      subjectDescription: "Informatica",
      classe: "4IA",
      subjectCode: "ckosk",
      duration: 1,
      code: "NDK",
      position: 1,
      eventId: 1,
    );

    test('two lessons one after another', () {
      List<Lesson> lessons = [];
      lessons.add(lesson);
      lessons.add(lesson.copyWith(position: 2, duration: 1, eventId: 2));

      expect(1, GlobalUtils.getGroupedLessonsList(lessons).length);
    });

    test('same lesson argument but different subjects in one day', () {
      List<Lesson> lessons = [];
      lessons.add(lesson);
      lessons.add(lesson.copyWith(subjectId: 2));
      expect(2, GlobalUtils.getGroupedLessonsList(lessons).length);
    });

    test('2 hours at the end of the day', () {
      List<Lesson> lessons = [];
      lessons.add(lesson);
      lessons.add(lesson.copyWith(subjectId: 2));
      lessons.add(lesson.copyWith(subjectId: 3));
      lessons.add(lesson.copyWith(subjectId: 3));
      expect(3, GlobalUtils.getGroupedLessonsList(lessons).length);
      expect(
        1,
        GlobalUtils.getGroupedLessonsList(lessons)
            .where((s) => s.subjectId == 3)
            .length,
      );

      //expect(2, GlobalUtils.getGroupedLessonsList(lessons).last.duration);
    });
  });
}
