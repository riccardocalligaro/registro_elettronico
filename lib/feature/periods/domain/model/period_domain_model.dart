import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class PeriodDomainModel {
  String? code;
  int? position;
  String? description;
  bool? isFinal;
  DateTime? start;
  DateTime? end;
  String? miurDivisionCode;

  PeriodDomainModel({
    required this.code,
    required this.position,
    required this.description,
    required this.isFinal,
    required this.start,
    required this.end,
    required this.miurDivisionCode,
  });

  PeriodDomainModel.fromLocalModel(PeriodLocalModel l) {
    this.code = l.code;
    this.position = l.position;
    this.description = l.description;
    this.isFinal = l.isFinal;
    this.start = l.start;
    this.end = l.end;
    this.miurDivisionCode = l.miurDivisionCode;
  }

  PeriodDomainModel copyWith({
    String? code,
    int? position,
    String? description,
    bool? isFinal,
    DateTime? start,
    DateTime? end,
    String? miurDivisionCode,
  }) {
    return PeriodDomainModel(
      code: code ?? this.code,
      position: position ?? this.position,
      description: description ?? this.description,
      isFinal: isFinal ?? this.isFinal,
      start: start ?? this.start,
      end: end ?? this.end,
      miurDivisionCode: miurDivisionCode ?? this.miurDivisionCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'position': position,
      'description': description,
      'isFinal': isFinal,
      'start': start?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'miurDivisionCode': miurDivisionCode,
    };
  }

  static PeriodDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return PeriodDomainModel(
      code: map['code'],
      position: map['position'],
      description: map['description'],
      isFinal: map['isFinal'],
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
      miurDivisionCode: map['miurDivisionCode'],
    );
  }

  String toJson() => json.encode(toMap());

  static PeriodDomainModel? fromJson(String source) =>
      PeriodDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PeriodDomainModel(code: $code, position: $position, description: $description, isFinal: $isFinal, start: $start, end: $end, miurDivisionCode: $miurDivisionCode)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PeriodDomainModel &&
        o.code == code &&
        o.position == position &&
        o.description == description &&
        o.isFinal == isFinal &&
        o.start == start &&
        o.end == end &&
        o.miurDivisionCode == miurDivisionCode;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        position.hashCode ^
        description.hashCode ^
        isFinal.hashCode ^
        start.hashCode ^
        end.hashCode ^
        miurDivisionCode.hashCode;
  }
}
