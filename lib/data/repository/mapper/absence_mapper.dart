import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/absences_response.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

// IntColumn get evtId => integer()();
// TextColumn get evtCode => text()();
// DateTimeColumn get evtDate => dateTime()();
// IntColumn get evtHPos => integer()();
// IntColumn get evtValue => integer()();
// BoolColumn get isJustified => boolean()();
// TextColumn get justifiedReasonCode => text()();
// TextColumn get justifReasonDesc => text()();

class AbsenceMapper {
  static db.Absence convertEventEntityToInsertable(AbsenceEvent event) {
    return db.Absence(
      evtId: event.evtId ?? 0,
      evtCode: event.evtCode ?? "",
      evtDate: DateUtils.getDateFromApiString(event.evtDate) ?? DateTime.now(),
      evtHPos: event.evtHPos ?? 0,
      evtValue: event.evtValue ?? 0,
      isJustified: event.isJustified ?? false,
      justifiedReasonCode: event.justifReasonCode ?? "",
      justifReasonDesc: event.justifReasonDesc ?? "",
    );
  }
}
