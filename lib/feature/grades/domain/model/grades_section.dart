import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/periods/domain/model/period_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';

class GradesPagesDomainModel {
  List<GradeDomainModel> grades;
  int newNotSeenGrades;
  int periods;
  List<PeriodWithGradesDomainModel> periodsWithGrades;

  GradesPagesDomainModel({
    @required this.grades,
    @required this.periodsWithGrades,
    @required this.periods,
    @required this.newNotSeenGrades,
  });
}

class PeriodWithGradesDomainModel {
  int overallObjective;

  List<GradeDomainModel> grades;

  List<GradeDomainModel> filteredGrades;

  /// The subject, the average, the grade you need for this objective
  List<PeriodGradeDomainModel> gradesForList;

  PeriodDomainModel period;

  /// The average grade for this period
  double average;

  List<FlSpot> averageSpots;

  List<FlSpot> normalSpots;

  PeriodWithGradesDomainModel({
    @required this.grades,
    @required this.period,
    @required this.average,
    @required this.gradesForList,
    @required this.averageSpots,
    @required this.normalSpots,
    @required this.overallObjective,
    @required this.filteredGrades,
  });
}

class PeriodGradeDomainModel {
  SubjectDomainModel subject;
  double average;
  GradeNeededDomainModel gradeNeededForObjective;
  List<GradeDomainModel> grades;
  int objective;

  PeriodGradeDomainModel({
    @required this.subject,
    @required this.average,
    @required this.gradeNeededForObjective,
    @required this.objective,
    @required this.grades,
  });
}

enum GradeNeededMessage {
  dont_worry,
  calculation_error,
  unreachable,
  get_at_lest,
  not_less_then
}

class GradeNeededDomainModel {
  GradeNeededMessage message;
  String value;

  GradeNeededDomainModel({
    @required this.message,
    this.value,
  });
}
