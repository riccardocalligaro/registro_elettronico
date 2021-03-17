import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/absences/domain/model/absences_response.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class AbsenceMapper {
  static db.Absence convertEventEntityToInsertable(AbsenceRemoteModel event) {
    return db.Absence(
      evtId: event.evtId ?? 0,
      evtCode: event.evtCode ?? "",
      evtDate: SRDateUtils.getDateFromApiString(event.evtDate) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      evtHPos: event.evtHPos ?? 0,
      evtValue: event.evtValue ?? 0,
      isJustified: event.isJustified ?? false,
      justifiedReasonCode: event.justifReasonCode ?? "",
      justifReasonDesc: event.justifReasonDesc ?? "",
    );
  }
}
