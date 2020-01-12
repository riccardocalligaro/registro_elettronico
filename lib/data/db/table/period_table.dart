import 'package:moor_flutter/moor_flutter.dart';

/// "periodCode": "Q3",
/// "periodPos": 3,
/// "periodDesc": "Periodo (pentamestre)",
/// "isFinal": true,
/// "dateStart": "2019-12-22",
/// "dateEnd": "2020-06-06",
/// "miurDivisionCode": null

class Periods extends Table {
  TextColumn get code => text()();
  IntColumn get position => integer()();
  TextColumn get description => text()();
  BoolColumn get isFinal => boolean()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  TextColumn get miurDivisionCode => text()();
  IntColumn get periodIndex => integer()();

  @override
  Set<Column> get primaryKey => {start, end};
}
