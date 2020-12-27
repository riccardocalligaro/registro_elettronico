class AbsencesRemoteModel {
  List<AbsenceRemoteModel> events;

  AbsencesRemoteModel({this.events});

  AbsencesRemoteModel.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = new List<AbsenceRemoteModel>();
      json['events'].forEach((v) {
        events.add(new AbsenceRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AbsenceRemoteModel {
  int evtId;
  String evtCode;
  String evtDate;
  int evtHPos;
  int evtValue;
  bool isJustified;
  String justifReasonCode;
  String justifReasonDesc;

  AbsenceRemoteModel({
    this.evtId,
    this.evtCode,
    this.evtDate,
    this.evtHPos,
    this.evtValue,
    this.isJustified,
    this.justifReasonCode,
    this.justifReasonDesc,
  });

  AbsenceRemoteModel.fromJson(Map<String, dynamic> json) {
    evtId = json['evtId'];
    evtCode = json['evtCode'];
    evtDate = json['evtDate'];
    evtHPos = json['evtHPos'];
    evtValue = json['evtValue'];
    isJustified = json['isJustified'];
    justifReasonCode = json['justifReasonCode'];
    justifReasonDesc = json['justifReasonDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['evtId'] = this.evtId;
    data['evtCode'] = this.evtCode;
    data['evtDate'] = this.evtDate;
    data['evtHPos'] = this.evtHPos;
    data['evtValue'] = this.evtValue;
    data['isJustified'] = this.isJustified;
    data['justifReasonCode'] = this.justifReasonCode;
    data['justifReasonDesc'] = this.justifReasonDesc;
    return data;
  }
}
