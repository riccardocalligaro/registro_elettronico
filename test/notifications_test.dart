import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:tuple/tuple.dart';

void main() {
  Grade getMockGrade(int id, double value) {
    return Grade(
        subjectId: 2,
        subjectDesc: "Matematica",
        evtId: id,
        evtCode: "jcask2",
        eventDate: DateTime.now(),
        decimalValue: value,
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
        localllyCancelled: false);
  }

  group('comparison', () {
    test('grades', () {
      final grade1 = getMockGrade(1, 4.0);
      final grade2 = getMockGrade(2, 6.0);
      final grade3 = getMockGrade(3, 8.0);

      final gradesBeforeFetching = [grade1, grade2, grade3]
          .map((g) => Tuple2(g.evtId, g.decimalValue))
          .toList();

      final grade4 = getMockGrade(4, 7.0);
      final grade5 = getMockGrade(3, 7.0);
      final grade6 = getMockGrade(3, 8.0);

      final gradesAfterFetching = [
        grade1,
        grade2,
        grade3,
        grade4,
        grade5,
        grade6
      ].map((g) => Tuple2(g.evtId, g.decimalValue)).toList();

      var gradesToNotify = [];

      gradesAfterFetching.forEach(
        (grade) => {
          if (!gradesBeforeFetching.contains(grade)) gradesToNotify.add(grade)
        },
      );

      expect(2, gradesToNotify.length);
    });
  });
  group('Test notifications date', () {
    var date = DateTime.utc(2020, 02, 11);
    initializeDateFormatting('it_IT');
    final String converted = DateUtils.convertDateLocale(date, 'it_IT');
    test('convert date for notificaitons', () {
      expect('11 febbraio 2020', converted);
    });
  });
}
