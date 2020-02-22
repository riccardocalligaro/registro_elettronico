import 'package:flutter/material.dart';

class SubjectAverages {
  final double average;
  final double praticoAverage;
  final double scrittoAverage;
  final double oraleAverage;
  //final int insufficienze;
  //final int sufficienze;

  SubjectAverages({
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
