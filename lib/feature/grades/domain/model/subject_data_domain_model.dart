import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';

class SubjectDataDomainModel {
  Subject subject;
  Professor professor;
  List<GradeDomainModel> grades;
  int objective;
  SubjectAveragesDomainModel averages;
}

class SubjectAveragesDomainModel {
  final double average;
  final double praticoAverage;
  final double scrittoAverage;
  final double oraleAverage;

  SubjectAveragesDomainModel({
    @required this.praticoAverage,
    @required this.scrittoAverage,
    @required this.oraleAverage,
    @required this.average,
  });

  String get averageValue => (!this.average.isNaN || this.average > 0)
      ? this.average.toStringAsFixed(2)
      : "-";
  String get praticoAverageValue =>
      !this.praticoAverage.isNaN ? this.praticoAverage.toStringAsFixed(2) : "";
  String get scrittoAverageValue =>
      !this.scrittoAverage.isNaN ? this.scrittoAverage.toStringAsFixed(2) : "";
  String get oraleAverageValue =>
      !this.oraleAverage.isNaN ? this.oraleAverage.toStringAsFixed(2) : "";
}
