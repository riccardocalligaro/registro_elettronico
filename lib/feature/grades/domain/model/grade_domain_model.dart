import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class GradeDomainModel {
  int subjectId;
  String subjectDesc;
  int evtId;
  String evtCode;
  DateTime eventDate;
  double decimalValue;
  String displayValue;
  int displayPos;
  String notesForFamily;
  bool cancelled;
  bool underlined;
  int periodPos;
  String periodDesc;
  int componentPos;
  String componentDesc;
  int weightFactor;
  int skillId;
  int gradeMasterId;
  bool localllyCancelled;
  bool hasSeenIt;

  GradeDomainModel({
    this.subjectId,
    this.subjectDesc,
    this.evtId,
    this.evtCode,
    this.eventDate,
    this.decimalValue,
    this.displayValue,
    this.displayPos,
    this.notesForFamily,
    this.cancelled,
    this.underlined,
    this.periodPos,
    this.periodDesc,
    this.componentPos,
    this.componentDesc,
    this.weightFactor,
    this.skillId,
    this.gradeMasterId,
    this.localllyCancelled,
    this.hasSeenIt,
  });

  GradeDomainModel.fromLocalGrade(LocalGrade l) {
    this.subjectId = l.subjectId;
    this.evtId = l.id;
    this.eventDate = l.eventDate;
    this.decimalValue = l.decimalValue;
    this.displayValue = l.displayValue;
    this.cancelled = l.cancelled;
    this.underlined = l.underlined;
    this.periodPos = l.periodPos;
  }

  GradeDomainModel.fromLocalModel(GradeLocalModel l) {
    this.subjectId = l.subjectId;
    this.subjectDesc = l.subjectDesc;
    this.evtId = l.evtId;
    this.evtCode = l.evtCode;
    this.eventDate = l.eventDate;
    this.decimalValue = l.decimalValue;
    this.displayValue = l.displayValue;
    this.displayPos = l.displayPos;
    this.notesForFamily = l.notesForFamily;
    this.cancelled = l.cancelled;
    this.underlined = l.underlined;
    this.periodPos = l.periodPos;
    this.periodDesc = l.periodDesc;
    this.componentPos = l.componentPos;
    this.componentDesc = l.componentDesc;
    this.weightFactor = l.weightFactor;
    this.localllyCancelled = l.localllyCancelled;
    this.hasSeenIt = l.hasSeenIt;
  }

  LocalGrade toLocalGrade() {
    return LocalGrade(
      subjectId: this.subjectId ?? .1,
      id: this.evtId,
      eventDate: this.eventDate ?? DateTime.fromMillisecondsSinceEpoch(0),
      decimalValue: this.decimalValue ?? -1,
      displayValue: this.displayValue ?? '',
      cancelled: this.cancelled ?? false,
      underlined: this.underlined ?? false,
      periodPos: this.periodPos ?? -1,
    );
  }

  GradeLocalModel toLocalModel() {
    return GradeLocalModel(
      subjectId: this.subjectId ?? -1,
      subjectDesc: this.subjectDesc ?? '',
      evtId: this.evtId ?? -1,
      evtCode: this.evtCode ?? '',
      eventDate: this.eventDate ?? DateTime.fromMillisecondsSinceEpoch(0),
      decimalValue: this.decimalValue ?? -1,
      displayValue: this.displayValue ?? -1,
      displayPos: this.displayPos ?? -1,
      notesForFamily: this.notesForFamily ?? '',
      cancelled: this.cancelled ?? false,
      underlined: this.underlined ?? false,
      periodPos: this.periodPos ?? -1,
      periodDesc: this.periodDesc ?? '',
      componentPos: this.componentPos ?? '',
      componentDesc: this.componentDesc ?? '',
      weightFactor: this.weightFactor ?? -1,
      skillId: this.skillId ?? -1,
      gradeMasterId: this.gradeMasterId ?? -1,
      localllyCancelled: this.localllyCancelled ?? false,
      hasSeenIt: this.hasSeenIt ?? false,
    );
  }

  GradeDomainModel copyWith({
    int subjectId,
    String subjectDesc,
    int evtId,
    String evtCode,
    DateTime eventDate,
    double decimalValue,
    String displayValue,
    int displayPos,
    String notesForFamily,
    bool cancelled,
    bool underlined,
    int periodPos,
    String periodDesc,
    int componentPos,
    String componentDesc,
    int weightFactor,
    int skillId,
    int gradeMasterId,
    bool localllyCancelled,
  }) {
    return GradeDomainModel(
      subjectId: subjectId ?? this.subjectId,
      subjectDesc: subjectDesc ?? this.subjectDesc,
      evtId: evtId ?? this.evtId,
      evtCode: evtCode ?? this.evtCode,
      eventDate: eventDate ?? this.eventDate,
      decimalValue: decimalValue ?? this.decimalValue,
      displayValue: displayValue ?? this.displayValue,
      displayPos: displayPos ?? this.displayPos,
      notesForFamily: notesForFamily ?? this.notesForFamily,
      cancelled: cancelled ?? this.cancelled,
      underlined: underlined ?? this.underlined,
      periodPos: periodPos ?? this.periodPos,
      periodDesc: periodDesc ?? this.periodDesc,
      componentPos: componentPos ?? this.componentPos,
      componentDesc: componentDesc ?? this.componentDesc,
      weightFactor: weightFactor ?? this.weightFactor,
      skillId: skillId ?? this.skillId,
      gradeMasterId: gradeMasterId ?? this.gradeMasterId,
      localllyCancelled: localllyCancelled ?? this.localllyCancelled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectDesc': subjectDesc,
      'evtId': evtId,
      'evtCode': evtCode,
      'eventDate': eventDate?.millisecondsSinceEpoch,
      'decimalValue': decimalValue,
      'displayValue': displayValue,
      'displayPos': displayPos,
      'notesForFamily': notesForFamily,
      'cancelled': cancelled,
      'underlined': underlined,
      'periodPos': periodPos,
      'periodDesc': periodDesc,
      'componentPos': componentPos,
      'componentDesc': componentDesc,
      'weightFactor': weightFactor,
      'skillId': skillId,
      'gradeMasterId': gradeMasterId,
      'localllyCancelled': localllyCancelled,
    };
  }

  factory GradeDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GradeDomainModel(
      subjectId: map['subjectId'],
      subjectDesc: map['subjectDesc'],
      evtId: map['evtId'],
      evtCode: map['evtCode'],
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      decimalValue: map['decimalValue'],
      displayValue: map['displayValue'],
      displayPos: map['displayPos'],
      notesForFamily: map['notesForFamily'],
      cancelled: map['cancelled'],
      underlined: map['underlined'],
      periodPos: map['periodPos'],
      periodDesc: map['periodDesc'],
      componentPos: map['componentPos'],
      componentDesc: map['componentDesc'],
      weightFactor: map['weightFactor'],
      skillId: map['skillId'],
      gradeMasterId: map['gradeMasterId'],
      localllyCancelled: map['localllyCancelled'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GradeDomainModel.fromJson(String source) =>
      GradeDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GradeDomainModel(subjectId: $subjectId, subjectDesc: $subjectDesc, evtId: $evtId, evtCode: $evtCode, eventDate: $eventDate, decimalValue: $decimalValue, displayValue: $displayValue, displayPos: $displayPos, notesForFamily: $notesForFamily, cancelled: $cancelled, underlined: $underlined, periodPos: $periodPos, periodDesc: $periodDesc, componentPos: $componentPos, componentDesc: $componentDesc, weightFactor: $weightFactor, skillId: $skillId, gradeMasterId: $gradeMasterId, localllyCancelled: $localllyCancelled)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GradeDomainModel &&
        o.subjectId == subjectId &&
        o.subjectDesc == subjectDesc &&
        o.evtId == evtId &&
        o.evtCode == evtCode &&
        o.eventDate == eventDate &&
        o.decimalValue == decimalValue &&
        o.displayValue == displayValue &&
        o.displayPos == displayPos &&
        o.notesForFamily == notesForFamily &&
        o.cancelled == cancelled &&
        o.underlined == underlined &&
        o.periodPos == periodPos &&
        o.periodDesc == periodDesc &&
        o.componentPos == componentPos &&
        o.componentDesc == componentDesc &&
        o.weightFactor == weightFactor &&
        o.skillId == skillId &&
        o.gradeMasterId == gradeMasterId &&
        o.localllyCancelled == localllyCancelled;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
        subjectDesc.hashCode ^
        evtId.hashCode ^
        evtCode.hashCode ^
        eventDate.hashCode ^
        decimalValue.hashCode ^
        displayValue.hashCode ^
        displayPos.hashCode ^
        notesForFamily.hashCode ^
        cancelled.hashCode ^
        underlined.hashCode ^
        periodPos.hashCode ^
        periodDesc.hashCode ^
        componentPos.hashCode ^
        componentDesc.hashCode ^
        weightFactor.hashCode ^
        skillId.hashCode ^
        gradeMasterId.hashCode ^
        localllyCancelled.hashCode;
  }
}
