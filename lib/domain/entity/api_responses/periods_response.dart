class PeriodsResponse {
  List<Period> periods;

  PeriodsResponse({this.periods});

  PeriodsResponse.fromJson(Map<String, dynamic> json) {
    if (json['periods'] != null) {
      periods = new List<Period>();
      json['periods'].forEach((v) {
        periods.add(new Period.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.periods != null) {
      data['periods'] = this.periods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Period {
  String periodCode;
  int periodPos;
  String periodDesc;
  bool isFinal;
  String dateStart;
  String dateEnd;
  Null miurDivisionCode;

  Period(
      {this.periodCode,
      this.periodPos,
      this.periodDesc,
      this.isFinal,
      this.dateStart,
      this.dateEnd,
      this.miurDivisionCode});

  Period.fromJson(Map<String, dynamic> json) {
    periodCode = json['periodCode'];
    periodPos = json['periodPos'];
    periodDesc = json['periodDesc'];
    isFinal = json['isFinal'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    miurDivisionCode = json['miurDivisionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
