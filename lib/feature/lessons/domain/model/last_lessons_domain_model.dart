import 'dart:convert';

import 'package:flutter/foundation.dart';

class LessonWithDurationDomainModel {
  int subject;
  int duration;
  String lessonArgoment;

  LessonWithDurationDomainModel({
    @required this.subject,
    @required this.duration,
    @required this.lessonArgoment,
  });
}

class UniqueLessionDomainModel {
  int subjectId;
  String argoment;

  UniqueLessionDomainModel({
    @required this.subjectId,
    @required this.argoment,
  });

  UniqueLessionDomainModel copyWith({
    int subjectId,
    String argoment,
  }) {
    return UniqueLessionDomainModel(
      subjectId: subjectId ?? this.subjectId,
      argoment: argoment ?? this.argoment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'argoment': argoment,
    };
  }

  factory UniqueLessionDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UniqueLessionDomainModel(
      subjectId: map['subjectId'],
      argoment: map['argoment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UniqueLessionDomainModel.fromJson(String source) =>
      UniqueLessionDomainModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniqueLessionDomainModel(subjectId: $subjectId, argoment: $argoment)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UniqueLessionDomainModel &&
        o.subjectId == subjectId &&
        o.argoment == argoment;
  }

  @override
  int get hashCode => subjectId.hashCode ^ argoment.hashCode;
}
