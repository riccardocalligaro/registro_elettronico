import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/periods/data/model/period_remote_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

// TextColumn get code => text()();
// IntColumn get position => integer()();
// TextColumn get description => text()();
// BoolColumn get isFinal => boolean()();
// DateTimeColumn get start => dateTime()();
// DateTimeColumn get end => dateTime()();
// TextColumn get miurDivisionCode => text()();

class PeriodMapper {
  static db.Period convertEventEntityToInsertable(
      PeriodRemoteModel period, int index) {
    return db.Period(
      code: period.periodCode ?? "",
      position: period.periodPos ?? -1,
      description: period.periodDesc ?? "",
      isFinal: period.isFinal ?? "",
      start: DateUtils.getDateFromApiString(period.dateStart) ??
          DateTime.utc(DateTime.now().year, DateTime.september, 10),
      end: DateUtils.getDateFromApiString(period.dateEnd) ??
          DateTime.utc(DateTime.now().year, DateTime.june, 10),
      miurDivisionCode: period.miurDivisionCode ?? "",
      periodIndex: index ?? -1,
    );
  }
}
