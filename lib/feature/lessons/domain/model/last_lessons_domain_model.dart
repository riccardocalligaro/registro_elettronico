import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';

class LessonWithDurationDomainModel {
  int duration;
  LessonDomainModel lesson;

  LessonWithDurationDomainModel({
    @required this.duration,
    @required this.lesson,
  });
}

class UniqueLessionDomainModel {
  int subjectId;
  String argoment;

  UniqueLessionDomainModel({
    @required this.subjectId,
    @required this.argoment,
  });

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
