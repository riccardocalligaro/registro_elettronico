import 'package:moor/moor.dart';

class Absences extends Table {
  IntColumn? get evtId => integer()();
  TextColumn? get evtCode => text()();
  DateTimeColumn? get evtDate => dateTime()();
  IntColumn? get evtHPos => integer()();
  IntColumn? get evtValue => integer()();
  BoolColumn? get isJustified => boolean()();
  TextColumn? get justifiedReasonCode => text()();
  TextColumn? get justifReasonDesc => text()();

  @override
  Set<Column> get primaryKey => {evtId!};
}
