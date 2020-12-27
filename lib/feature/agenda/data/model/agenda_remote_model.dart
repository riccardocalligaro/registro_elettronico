class AgendaResponse {
  List<AgendaRemoteModel> events;

  AgendaResponse({this.events});

  AgendaResponse.fromJson(Map<String, dynamic> json) {
    if (json['agenda'] != null) {
      events = List<AgendaRemoteModel>();
      json['agenda'].forEach((v) {
        events.add(AgendaRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.events != null) {
      data['agenda'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AgendaRemoteModel {
  int evtId;
  String evtCode;
  String evtDatetimeBegin;
  String evtDatetimeEnd;
  bool isFullDay;
  String notes;
  String authorName;
  String classDesc;
  int subjectId;
  String subjectDesc;

  AgendaRemoteModel({
    this.evtId,
    this.evtCode,
    this.evtDatetimeBegin,
    this.evtDatetimeEnd,
    this.isFullDay,
    this.notes,
    this.authorName,
    this.classDesc,
    this.subjectId,
    this.subjectDesc,
  });

  AgendaRemoteModel.fromJson(Map<String, dynamic> json) {
    evtId = json['evtId'];
    evtCode = json['evtCode'];
    evtDatetimeBegin = json['evtDatetimeBegin'];
    evtDatetimeEnd = json['evtDatetimeEnd'];
    isFullDay = json['isFullDay'];
    notes = json['notes'];
    authorName = json['authorName'];
    classDesc = json['classDesc'];
    subjectId = json['subjectId'];
    subjectDesc = json['subjectDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['evtId'] = this.evtId;
    data['evtCode'] = this.evtCode;
    data['evtDatetimeBegin'] = this.evtDatetimeBegin;
    data['evtDatetimeEnd'] = this.evtDatetimeEnd;
    data['isFullDay'] = this.isFullDay;
    data['notes'] = this.notes;
    data['authorName'] = this.authorName;
    data['classDesc'] = this.classDesc;
    data['subjectId'] = this.subjectId;
    data['subjectDesc'] = this.subjectDesc;
    return data;
  }
}
