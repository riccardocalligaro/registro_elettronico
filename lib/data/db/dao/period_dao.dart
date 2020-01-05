import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/period_table.dart';

part 'period_dao.g.dart';

@UseDao(tables: [Periods])
class PeriodDao extends DatabaseAccessor<AppDatabase> with _$PeriodDaoMixin {
  AppDatabase db;
  PeriodDao(this.db) : super(db);

  Stream<List<Period>> watchAllPeriods() => select(periods).watch();

  Future<List<Period>> getAllPeriods() => select(periods).get();

  Future deleteAllPeriods() => delete(periods).go();

  Future insertPeriod(Period period) =>
      into(periods).insert(period, orReplace: true);

  Future insertPeriods(List<Period> periodsList) =>
      into(periods).insertAll(periodsList, orReplace: true);
}
