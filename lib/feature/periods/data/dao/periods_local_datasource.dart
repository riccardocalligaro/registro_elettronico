import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_local_model.dart';

part 'periods_local_datasource.g.dart';

@UseDao(tables: [Periods])
class PeriodsLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$PeriodsLocalDatasourceMixin {
  AppDatabase db;

  PeriodsLocalDatasource(this.db) : super(db);

  Stream<List<PeriodLocalModel>> watchAllPeriods() => select(periods).watch();

  Future<List<PeriodLocalModel>> getAllPeriods() => select(periods).get();

  Future deleteAllPeriods() => delete(periods).go();

  Future<void> insertPeriods(List<PeriodLocalModel> periodsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(periods, periodsList);
    });
  }

  Future<void> deletePeriods(List<PeriodLocalModel> periodsToDelete) async {
    await batch((batch) {
      periodsToDelete.forEach((entry) {
        batch.delete(periods, entry);
      });
    });
  }
}
