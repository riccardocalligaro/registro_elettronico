import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/grades_response.dart';

class GradeMapper {
  const GradeMapper();

  db.Grade convertGradeEntityToInserttable(Grades grade) {
    return db.Grade(
        subjectId: grade.subjectId,
        subjectDesc: grade.subjectDesc,
        evtId: grade.evtId,
        evtCode: grade.evtCode,
        eventDate: DateTime.parse(grade.evtDate),
        decimalValue: grade.decimalValue,
        displayValue: grade.displayValue,
        displayPos: grade.displaPos,
        notesForFamily: grade.notesForFamily,
        cancelled: grade.canceled,
        underlined: grade.underlined,
        periodPos: grade.periodPos,
        periodDesc: grade.periodDesc,
        componentPos: grade.componentPos,
        componentDesc: grade.componentDesc,
        weightFactor: grade.weightFactor,
        skillId: grade.skillId,
        gradeMasterId: grade.gradeMasterId);
  }
}
