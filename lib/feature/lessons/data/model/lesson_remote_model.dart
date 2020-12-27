class LessonsResponse {
  List<LessonRemoteModel> lessons;

  LessonsResponse({this.lessons});

  LessonsResponse.fromJson(Map<String, dynamic> json) {
    if (json['lessons'] != null) {
      lessons = List<LessonRemoteModel>();
      json['lessons'].forEach((v) {
        lessons.add(LessonRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.lessons != null) {
      data['lessons'] = this.lessons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  LessonRemoteModel(
      {this.evtId,
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
      this.lessonArg});

  LessonRemoteModel.fromJson(Map<String, dynamic> json) {
    evtId = json['evtId'];
    evtDate = json['evtDate'];
    evtCode = json['evtCode'];
    evtHPos = json['evtHPos'];
    evtDuration = json['evtDuration'];
    classDesc = json['classDesc'];
    authorName = json['authorName'];
    subjectId = json['subjectId'];
    subjectCode = json['subjectCode'];
    subjectDesc = json['subjectDesc'];
    lessonType = json['lessonType'];
    lessonArg = json['lessonArg'];
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
}
