import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_chart.dart';

class PeriodTab extends StatelessWidget {
  final PeriodWithGradesDomainModel periodWithGradesDomainModel;

  const PeriodTab({
    Key key,
    @required this.periodWithGradesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GradesChart(
          averageSpots: periodWithGradesDomainModel.averageSpots,
          normalSpots: periodWithGradesDomainModel.normalSpots,
          overallObjective: periodWithGradesDomainModel.overallObjective,
          grades: periodWithGradesDomainModel.grades,
        ),
      ],
    );
  }
}
