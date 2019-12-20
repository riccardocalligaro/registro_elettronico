import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

class OverallStats {
  final double average;
  final int insufficienze;
  final int sufficienze;
  final double votoMin;
  final double votoMax;
  final Subject bestSubject;
  final Subject worstSubject;

  OverallStats({
    @required this.insufficienze,
    @required this.sufficienze,
    @required this.votoMin,
    @required this.votoMax,
    @required this.bestSubject,
    @required this.worstSubject,
    @required this.average,
  });
}
