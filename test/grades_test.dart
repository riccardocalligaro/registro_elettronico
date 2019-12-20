import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

void main() {
  group('Test grades overall stats', () {
    List<Subject> subjects = [];
    final subject1 = Subject(id: 423943, name: "Italiano", orderNumber: 1);
    //final subject2 = Subject(id: 423912343, name: "Matematica", orderNumber: 2);

    subjects.add(subject1);
    //subjects.add(subject2);

    List<Grade> grades = [];
    grades.add(
      new Grade(
        subjectId: 423943,
        subjectDesc: "Italiano",
        evtId: 321132,
        evtCode: "usdia39",
        eventDate: DateTime.now(),
        decimalValue: 8.0,
        displayValue: "8+",
        displayPos: 1,
        notesForFamily: "Verifica di italiano",
        cancelled: false,
        underlined: false,
        periodPos: 1,
        periodDesc: "Trimestre",
        componentPos: 1,
        componentDesc: "Orale",
        weightFactor: 0,
        skillId: 1,
        gradeMasterId: 1,
      ),
    );

    grades.add(
      new Grade(
        subjectId: 423943,
        subjectDesc: "Matematica",
        evtId: 765632,
        evtCode: "jcask2",
        eventDate: DateTime.now(),
        decimalValue: 2.0,
        displayValue: "2+",
        displayPos: 2,
        notesForFamily: "Verifica di mateamtica",
        cancelled: false,
        underlined: false,
        periodPos: 1,
        periodDesc: "Trimestre",
        componentPos: 1,
        componentDesc: "Orale",
        weightFactor: 0,
        skillId: 1,
        gradeMasterId: 1,
      ),
    );

    final map = Map.fromIterable(subjects,
        key: (e) => e,
        value: (e) =>
            grades.where((grade) => grade.subjectId == e.id).toList());

    final stats = GlobalUtils.getOverallStatsFromSubjectGradesMap(map, 1);

    test(
      'test best and worst subject',
      () {
        expect(true, stats.bestSubject.id == subject1.id,
            reason: "italiano shoudl be best subject based on grades");
      },
    );

    test(
      'test insufficienze and insufficienze',
      () {
        expect(1, stats.insufficienze);
        expect(1, stats.sufficienze);
      },
    );

    test(
      'test voto minimo and voto max',
      () {
        expect(2.0, stats.votoMin);
        expect(8.0, stats.votoMax);
      },
    );
  });
}
