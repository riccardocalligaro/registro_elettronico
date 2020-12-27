import 'package:moor/moor.dart';

//"evtId": 1832573,
//"evtCode": "ABR0",
//"evtDate": "2019-11-14",
//"evtHPos": 1,
//"evtValue": 2,
//"isJustified": true,
//"justifReasonCode": "A",
//"justifReasonDesc": "Motivi di salute"

class Absences extends Table {
  IntColumn get evtId => integer()();
  TextColumn get evtCode => text()();
  DateTimeColumn get evtDate => dateTime()();
  IntColumn get evtHPos => integer()();
  IntColumn get evtValue => integer()();
  BoolColumn get isJustified => boolean()();
  TextColumn get justifiedReasonCode => text()();
  TextColumn get justifReasonDesc => text()();

  @override
  Set<Column> get primaryKey => {evtId};
}
