import 'package:moor/moor.dart';

@DataClassName('PeriodLocalModel')
class Periods extends Table {
  TextColumn? get code => text()();
  IntColumn? get position => integer()();
  TextColumn? get description => text()();
  BoolColumn? get isFinal => boolean()();
  DateTimeColumn? get start => dateTime()();
  DateTimeColumn? get end => dateTime()();
  TextColumn? get miurDivisionCode => text()();
  IntColumn? get periodIndex => integer()();

  @override
  Set<Column> get primaryKey => {start!, end!};
}
