import 'package:registro_elettronico/core/data/local/moor_database.dart';

class LessonRemoteModel {
  int evtId;
  String evtDate;
  String evtCode;
  int evtHPos;
  int evtDuration;
  String classDesc;
  String authorName;
  int subjectId;
  String subjectCode;
  String subjectDesc;
  String lessonType;
  String lessonArg;

  LessonRemoteModel({
    this.evtId,
    this.evtDate,
    this.evtCode,
    this.evtHPos,
    this.evtDuration,
    this.classDesc,
    this.authorName,
    this.subjectId,
    this.subjectCode,
    this.subjectDesc,
    this.lessonType,
    this.lessonArg,
  });

  LessonRemoteModel.fromJson(Map<String, dynamic> json) {
    evtId = json['evtId'];
    evtDate = json['evtDate'];
    evtCode = json['evtCode'];
    evtHPos = json['evtHPos'];
    evtDuration = _safeInt(json['evtDuration']);
    classDesc = json['classDesc'];
    authorName = json['authorName'];
    subjectId = json['subjectId'];
    subjectCode = json['subjectCode'];
    subjectDesc = json['subjectDesc'];
    lessonType = json['lessonType'];
    lessonArg = json['lessonArg'];
  }

  int _safeInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.round();
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['evtId'] = this.evtId;
    data['evtDate'] = this.evtDate;
    data['evtCode'] = this.evtCode;
    data['evtHPos'] = this.evtHPos;
    data['evtDuration'] = this.evtDuration;
    data['classDesc'] = this.classDesc;
    data['authorName'] = this.authorName;
    data['subjectId'] = this.subjectId;
    data['subjectCode'] = this.subjectCode;
    data['subjectDesc'] = this.subjectDesc;
    data['lessonType'] = this.lessonType;
    data['lessonArg'] = this.lessonArg;
    return data;
  }

  LessonLocalModel toLocalModel() {
    return LessonLocalModel(
      eventId: this.evtId ?? -1,
      date: DateTime.tryParse(this.evtDate) ?? DateTime.now(),
      code: this.evtCode ?? '',
      position: this.evtHPos ?? -1,
      duration: this.evtDuration ?? -1,
      classe: this.classDesc ?? '',
      author: this.authorName ?? '',
      subjectId: this.subjectId ?? -1,
      subjectCode: this.subjectCode ?? '',
      subjectDescription: this.subjectDesc ?? '',
      lessonType: this.lessonType ?? '',
      lessonArg: this.lessonArg ?? '',
    );
  }
}
