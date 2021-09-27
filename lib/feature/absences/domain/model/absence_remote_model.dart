class AbsenceRemoteModel {
  int? evtId;
  String? evtCode;
  String? evtDate;
  int? evtHPos;
  int? evtValue;
  bool? isJustified;
  String? justifReasonCode;
  String? justifReasonDesc;

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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
