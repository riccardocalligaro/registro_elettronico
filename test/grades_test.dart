import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

void main() {
  group('Color for different grades', () {
    final gradeRed = Grade(
      subjectId: 1,
      subjectDesc: "Italiano",
      evtId: 1,
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
    );
    test('If grade is sufficient (>=6)', () {
      final color = GlobalUtils.getColorFromGrade(gradeRed);
      expect(Colors.green, color);
    });

    test('Blue if grade is cancelled', () {
      final color =
          GlobalUtils.getColorFromGrade(gradeRed.copyWith(cancelled: true));
      expect(Colors.blue, color);
    });

    test('Blue if is -1', () {
      final color =
          GlobalUtils.getColorFromGrade(gradeRed.copyWith(decimalValue: -1.00));
      expect(Colors.blue, color);
    });

    test('Red if is unfficient (< 5.5)', () {
      final color =
          GlobalUtils.getColorFromGrade(gradeRed.copyWith(decimalValue: 4.00));
      expect(Colors.red, color);
    });

    test('Yellow if is nearly sufficient (5.5 <= grade < 6)', () {
      final color =
          GlobalUtils.getColorFromGrade(gradeRed.copyWith(decimalValue: 5.58));
      expect(Colors.yellow[700], color);
    });
  });

  group('Test grades overall stats', () {
    List<Subject> subjects = [];
    // Create some sample subjects
    final subject1 = Subject(id: 1, name: "Italiano", orderNumber: 1);
    final subject2 = Subject(id: 2, name: "Matematica", orderNumber: 2);
    final subject3 = Subject(id: 3, name: "Storia", orderNumber: 3);

    subjects.add(subject1);
    subjects.add(subject2);
    subjects.add(subject3);

    List<Grade> grades = [];
    grades.add(
      new Grade(
        subjectId: 1,
        subjectDesc: "Italiano",
        evtId: 1,
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
        subjectId: 2,
        subjectDesc: "Matematica",
        evtId: 2,
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

    grades.add(
      new Grade(
        subjectId: 3,
        subjectDesc: "Storia",
        evtId: 3,
        evtCode: "hdasj2",
        eventDate: DateTime.now(),
        decimalValue: -1.00,
        displayValue: "+",
        displayPos: 3,
        notesForFamily: "Esercitazione per fase",
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

    final stats =
        GlobalUtils.getOverallStatsFromSubjectGradesMap(subjects, grades, 1);

    test(
      'test best and worst subject',
      () {
        expect(true, stats.bestSubject.id == subject1.id,
            reason: "italiano shoudl be best subject based on grades");
      },
    );

    test(
      'Show correct minimum grade and max grade',
      () {
        expect(2.0, stats.votoMin);
        expect(8.0, stats.votoMax);
      },
    );

    test(
      'Show correct insufficienze and sufficienze',
      () {
        //expect(1, stats.sufficienze);
        expect(1, stats.insufficienze);
      },
    );
    test('Show correct average', () {
      expect(8.0, GlobalUtils.getSubjectAveragesFromGrades(grades, 1).average);
      expect(2.0, GlobalUtils.getSubjectAveragesFromGrades(grades, 2).average);
      expect(true,
          GlobalUtils.getSubjectAveragesFromGrades(grades, 3).average.isNaN);
    });

    test('Show correct color of circular progess bar', () {
      final averageBlue = GlobalUtils.getSubjectAveragesFromGrades(grades, 3);
      expect(Colors.blue, GlobalUtils.getColorFromAverage(averageBlue.average));
      final averageGreeen = GlobalUtils.getSubjectAveragesFromGrades(grades, 1);
      expect(
          Colors.green, GlobalUtils.getColorFromAverage(averageGreeen.average));
    });

    test('Show correct percent of circular progess bar', () {
      final average = GlobalUtils.getSubjectAveragesFromGrades(grades, 3);
      expect(0.0, (average.average / 10).isNaN ? 0.0 : average.average / 10);
    });

    test('Show correct subjects in the grades page', () {
      Map<Subject, double> subjectsValues = Map.fromIterable(subjects,
          key: (e) => e, value: (e) => GlobalUtils.getAverage(e.id, grades));
      final period = 1;
      // Get the grades in the rigt order

      final gradesForPeriod =
          grades.where((grade) => grade.periodPos == period).toList();

      var sortedKeys = subjectsValues.keys.toList()
        ..removeWhere((subject) {
          bool contains = true;
          gradesForPeriod.forEach((grade) {
            if (grade.subjectId == subject.id) {
              contains = false;
            }
          });
          return contains;
        })
        ..sort((k2, k1) => subjectsValues[k1].compareTo(subjectsValues[k2]));

      LinkedHashMap<Subject, double> sortedMap = new LinkedHashMap.fromIterable(
          sortedKeys,
          key: (k) => k,
          value: (k) => subjectsValues[k]);

      expect(3, sortedMap.length);
    });
  });
}
