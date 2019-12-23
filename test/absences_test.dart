import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

void main() {
  group("Test absences", () {
    //"evtId": 1832573,
    //"evtCode": "ABR0",
    //"evtDate": "2019-11-14",
    //"evtHPos": 1,
    //"evtValue": 2,
    //"isJustified": true,
    //"justifReasonCode": "A",
    //"justifReasonDesc": "Motivi di salute"
    /// ABA0 assenza
    /// ABU0 uscita
    /// ABR0 ritardo
    /// ABR1 ritardo breve
    /// ABU0 uscita anticipata
    /// A ---- Health reasons
    /// AC --- Health reasons + medical certificate
    /// B ---- Family reasons
    final List<Absence> absences = [];
    final Absence absence1 = Absence(
        evtCode: "ABA0",
        evtId: 1,
        evtDate: DateUtils.getDateFromApiString('2019-11-14'),
        evtHPos: 1,
        evtValue: 2,
        isJustified: true,
        justifiedReasonCode: 'A',
        justifReasonDesc: 'Motivi di salute');

    absences.add(absence1);
    absences.add(absence1.copyWith(
        evtDate: DateUtils.getDateFromApiString('2019-11-15')));
    absences.add(absence1.copyWith(
        evtDate: DateUtils.getDateFromApiString('2019-11-16')));

    absences.add(absence1.copyWith(evtCode: "ABR0"));
    absences.add(absence1.copyWith(evtCode: "ABU0"));

    //final map = AbsencesPage().getAbsencesMap(absences);
    // test('show correct number with aba0 code', () {
    //   expect(1, map.keys.length);
    // });
  });
}
