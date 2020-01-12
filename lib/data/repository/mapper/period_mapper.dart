import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/periods_response.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

// TextColumn get code => text()();
// IntColumn get position => integer()();
// TextColumn get description => text()();
// BoolColumn get isFinal => boolean()();
// DateTimeColumn get start => dateTime()();
// DateTimeColumn get end => dateTime()();
// TextColumn get miurDivisionCode => text()();

class PeriodMapper {
  db.Period convertEventEntityToInsertable(Period period, int index) {
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
