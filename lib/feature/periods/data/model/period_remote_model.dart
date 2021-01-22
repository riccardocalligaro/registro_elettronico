class PeriodRemoteModel {
  String periodCode;
  int periodPos;
  String periodDesc;
  bool isFinal;
  String dateStart;
  String dateEnd;
  String miurDivisionCode;

  PeriodRemoteModel({
    this.periodCode,
    this.periodPos,
    this.periodDesc,
    this.isFinal,
    this.dateStart,
    this.dateEnd,
    this.miurDivisionCode,
  });

  PeriodRemoteModel.fromJson(Map<String, dynamic> json) {
    periodCode = json['periodCode'];
    periodPos = json['periodPos'];
    periodDesc = json['periodDesc'];
    isFinal = json['isFinal'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    miurDivisionCode = json['miurDivisionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['periodCode'] = this.periodCode;
    data['periodPos'] = this.periodPos;
    data['periodDesc'] = this.periodDesc;
    data['isFinal'] = this.isFinal;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['miurDivisionCode'] = this.miurDivisionCode;
    return data;
  }
}
