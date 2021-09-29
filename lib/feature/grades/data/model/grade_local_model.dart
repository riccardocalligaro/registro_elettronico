import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_remote_model.dart';

@DataClassName('GradeLocalModel')
class Grades extends Table {
  IntColumn? get subjectId => integer()();
  TextColumn? get subjectDesc => text()();
  IntColumn? get evtId => integer()();
  TextColumn? get evtCode => text()();
  DateTimeColumn? get eventDate => dateTime()();
  RealColumn? get decimalValue => real()();
  TextColumn? get displayValue => text()();
  IntColumn? get displayPos => integer()();
  TextColumn? get notesForFamily => text()();
  BoolColumn? get cancelled => boolean()();
  BoolColumn? get underlined => boolean()();
  IntColumn? get periodPos => integer()();
  TextColumn? get periodDesc => text()();
  IntColumn? get componentPos => integer()();
  TextColumn? get componentDesc => text()();
  IntColumn? get weightFactor => integer()();
  IntColumn? get skillId => integer()();
  IntColumn? get gradeMasterId => integer()();
  BoolColumn? get localllyCancelled => boolean()();
  BoolColumn? get hasSeenIt => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {evtId!};

  @override
  String get tableName => 'grades';
}

class GradeLocalModelConverter {
  static GradeLocalModel fromRemoteModel(
    GradeRemoteModel remoteModel,
    GradeLocalModel? localModel,
    bool? hasSeenIt,
  ) {
    return GradeLocalModel(
      subjectId: remoteModel.subjectId ?? -1,
      subjectDesc: remoteModel.subjectDesc ?? '',
      evtId: remoteModel.evtId ?? -1,
      evtCode: remoteModel.evtCode ?? '',
      eventDate: DateTime.tryParse(remoteModel.evtDate!) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      decimalValue: remoteModel.decimalValue ?? -1,
      displayValue: remoteModel.displayValue ?? '',
      displayPos: remoteModel.displaPos ?? -1,
      notesForFamily: remoteModel.notesForFamily ?? '',
      cancelled: remoteModel.canceled ?? false,
      underlined: remoteModel.underlined ?? false,
      periodPos: remoteModel.periodPos ?? -1,
      periodDesc: remoteModel.periodDesc ?? '',
      componentPos: remoteModel.componentPos ?? -1,
      componentDesc: remoteModel.componentDesc ?? '',
      weightFactor: remoteModel.weightFactor ?? -1,
      skillId: remoteModel.skillId ?? -1,
      gradeMasterId: remoteModel.gradeMasterId ?? -1,
      localllyCancelled:
          localModel != null ? localModel.localllyCancelled : false,
      hasSeenIt: hasSeenIt ?? false,
    );
  }
}
