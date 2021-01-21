import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:moor/moor.dart';
import 'package:registro_elettronico/feature/lessons/data/model/lesson_local_model.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_local_model.dart';

part 'lessons_local_datasource.g.dart';

@UseDao(tables: [
  Lessons,
  Professors,
])
class LessonsLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$LessonsLocalDatasourceMixin {
  AppDatabase db;

  LessonsLocalDatasource(this.db) : super(db);

  Stream<List<LessonLocalModel>> watchAllLessons() => select(lessons).watch();

  Future<List<LessonLocalModel>> getAllLessons() => select(lessons).get();

  Stream<List<LessonLocalModel>> watchLessonsForSubject(int subjectId) {
    return customSelect(
      'SELECT * FROM lessons WHERE subject_id = ? GROUP BY lesson_arg ORDER BY date DESC',
      readsFrom: {
        lessons,
      },
      variables: [
        Variable.withInt(subjectId),
      ],
    ).map((row) {
      return LessonLocalModel.fromData(row.data, db);
    }).watch();
  }

  Future<void> insertLessons(List<LessonLocalModel> lessonsToInsert) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(lessons, lessonsToInsert);
    });
  }

  Future<void> deleteLessons(List<LessonLocalModel> lessonsToDelete) async {
    await batch((batch) {
      lessonsToDelete.forEach((entry) {
        batch.delete(lessons, entry);
      });
    });
  }
}
