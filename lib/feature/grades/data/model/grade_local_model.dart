import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_remote_model.dart';

@DataClassName('GradeLocalModel')
class Grades extends Table {
  IntColumn get subjectId => integer()();
  TextColumn get subjectDesc => text()();
  IntColumn get evtId => integer()();
  TextColumn get evtCode => text()();
  DateTimeColumn get eventDate => dateTime()();
  RealColumn get decimalValue => real()();
  TextColumn get displayValue => text()();
  IntColumn get displayPos => integer()();
  TextColumn get notesForFamily => text()();
  BoolColumn get cancelled => boolean()();
  BoolColumn get underlined => boolean()();
  IntColumn get periodPos => integer()();
  TextColumn get periodDesc => text()();
  IntColumn get componentPos => integer()();
  TextColumn get componentDesc => text()();
  IntColumn get weightFactor => integer()();
  IntColumn get skillId => integer()();
  IntColumn get gradeMasterId => integer()();
  BoolColumn get localllyCancelled => boolean()();

  @override
  Set<Column> get primaryKey => {evtId};

  @override
  String get tableName => 'grades';
}

class GradeLocalModelConverter {
  static GradeLocalModel fromRemoteModel(
    GradeRemoteModel remoteModel,
    GradeLocalModel localModel,
  ) {
    return GradeLocalModel(
      subjectId: remoteModel.subjectId,
      subjectDesc: remoteModel.subjectDesc,
      evtId: remoteModel.evtId,
      evtCode: remoteModel.evtCode,
      eventDate: DateTime.parse(remoteModel.evtDate) ?? DateTime.now(),
      decimalValue: remoteModel.decimalValue,
      displayValue: remoteModel.displayValue,
      displayPos: remoteModel.displaPos,
      notesForFamily: remoteModel.notesForFamily,
      cancelled: remoteModel.canceled,
      underlined: remoteModel.underlined,
      periodPos: remoteModel.periodPos,
      periodDesc: remoteModel.periodDesc,
      componentPos: remoteModel.componentPos,
      componentDesc: remoteModel.componentDesc,
      weightFactor: remoteModel.weightFactor,
      skillId: remoteModel.skillId,
      gradeMasterId: remoteModel.gradeMasterId,
      localllyCancelled: localModel.cancelled,
    );
  }
}
