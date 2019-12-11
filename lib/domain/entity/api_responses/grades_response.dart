class GradesResponse {
  List<Grades> grades;

  GradesResponse({this.grades});

  GradesResponse.fromJson(Map<String, dynamic> json) {
    if (json['grades'] != null) {
      grades = new List<Grades>();
      json['grades'].forEach((v) {
        grades.add(new Grades.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.grades != null) {
      data['grades'] = this.grades.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Grades {
  int subjectId;
  String subjectCode;
  String subjectDesc;
  int evtId;
  String evtCode;
  String evtDate;
  double decimalValue;
  String displayValue;
  int displaPos;
  String notesForFamily;
  String color;
  bool canceled;
  bool underlined;
  int periodPos;
  String periodDesc;
  int componentPos;
  String componentDesc;
  int weightFactor;
  int skillId;
  int gradeMasterId;
  Null skillDesc;
  Null skillCode;
  int skillMasterId;
  int oldskillId;
  String oldskillDesc;

  Grades(
      {this.subjectId,
      this.subjectCode,
      this.subjectDesc,
      this.evtId,
      this.evtCode,
      this.evtDate,
      this.decimalValue,
      this.displayValue,
      this.displaPos,
      this.notesForFamily,
      this.color,
      this.canceled,
      this.underlined,
      this.periodPos,
      this.periodDesc,
      this.componentPos,
      this.componentDesc,
      this.weightFactor,
      this.skillId,
      this.gradeMasterId,
      this.skillDesc,
      this.skillCode,
      this.skillMasterId,
      this.oldskillId,
      this.oldskillDesc});

  Grades.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectCode = json['subjectCode'];
    subjectDesc = json['subjectDesc'];
    evtId = json['evtId'];
    evtCode = json['evtCode'];
    evtDate = json['evtDate'];
    decimalValue =
        json['decimalValue'] == null ? 0.0 : json['decimalValue'].toDouble();
    displayValue = json['displayValue'];
    displaPos = json['displaPos'];
    notesForFamily = json['notesForFamily'];
    color = json['color'];
    canceled = json['canceled'];
    underlined = json['underlined'];
    periodPos = json['periodPos'];
    periodDesc = json['periodDesc'];
    componentPos = json['componentPos'];
    componentDesc = json['componentDesc'];
    weightFactor = json['weightFactor'];
    skillId = json['skillId'];
    gradeMasterId = json['gradeMasterId'];
    skillDesc = json['skillDesc'];
    skillCode = json['skillCode'];
    skillMasterId = json['skillMasterId'];
    oldskillId = json['oldskillId'];
    oldskillDesc = json['oldskillDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectId'] = this.subjectId;
    data['subjectCode'] = this.subjectCode;
    data['subjectDesc'] = this.subjectDesc;
    data['evtId'] = this.evtId;
    data['evtCode'] = this.evtCode;
    data['evtDate'] = this.evtDate;
    data['decimalValue'] = this.decimalValue;
    data['displayValue'] = this.displayValue;
    data['displaPos'] = this.displaPos;
    data['notesForFamily'] = this.notesForFamily;
    data['color'] = this.color;
    data['canceled'] = this.canceled;
    data['underlined'] = this.underlined;
    data['periodPos'] = this.periodPos;
    data['periodDesc'] = this.periodDesc;
    data['componentPos'] = this.componentPos;
    data['componentDesc'] = this.componentDesc;
    data['weightFactor'] = this.weightFactor;
    data['skillId'] = this.skillId;
    data['gradeMasterId'] = this.gradeMasterId;
    data['skillDesc'] = this.skillDesc;
    data['skillCode'] = this.skillCode;
    data['skillMasterId'] = this.skillMasterId;
    data['oldskillId'] = this.oldskillId;
    data['oldskillDesc'] = this.oldskillDesc;
    return data;
  }
}
