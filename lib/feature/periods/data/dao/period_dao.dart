import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_local_model.dart';

part 'period_dao.g.dart';

@UseDao(tables: [Periods])
class PeriodDao extends DatabaseAccessor<AppDatabase> with _$PeriodDaoMixin {
  AppDatabase db;

  PeriodDao(this.db) : super(db);

  Stream<List<Period>> watchAllPeriods() => select(periods).watch();

  Future<List<Period>> getAllPeriods() => select(periods).get();

  Future deleteAllPeriods() => delete(periods).go();

  Future insertPeriod(Period period) =>
      into(periods).insertOnConflictUpdate(period);

  Future<void> insertPeriods(List<Period> periodsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(periods, periodsList);
    });
  }
}
