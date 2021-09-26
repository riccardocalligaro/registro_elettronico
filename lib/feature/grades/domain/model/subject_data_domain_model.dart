import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';

class SubjectDataDomainModel {
  List<FlSpot> normalSpots;
  List<FlSpot> averageSpots;

  PeriodGradeDomainModel data;
  List<ProfessorDomainModel> professors;
  List<String>? professorsString;

  SubjectAveragesDomainModel averages;

  SubjectDataDomainModel({
    required this.data,
    required this.professors,
    required this.averages,
    required this.averageSpots,
    required this.normalSpots,
  });
}

class SubjectAveragesDomainModel {
  final double average;
  final double praticoAverage;
  final double scrittoAverage;
  final double oraleAverage;

  SubjectAveragesDomainModel({
    required this.praticoAverage,
    required this.scrittoAverage,
    required this.oraleAverage,
    required this.average,
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
