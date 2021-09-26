import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class PeriodRemoteModel {
  String? periodCode;
  int? periodPos;
  String? periodDesc;
  bool? isFinal;
  String? dateStart;
  String? dateEnd;
  String? miurDivisionCode;

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

  PeriodLocalModel toLocalModel(int index) {
    return PeriodLocalModel(
      code: this.periodCode ?? '',
      position: this.periodPos ?? -1,
      description: this.periodDesc ?? '',
      isFinal: this.isFinal ?? '' as bool?,
      start: SRDateUtils.getDateFromApiString(this.dateStart),
      end: SRDateUtils.getDateFromApiString(this.dateEnd),
      miurDivisionCode: this.miurDivisionCode ?? "",
      periodIndex: index ?? -1,
    );
  }
}
