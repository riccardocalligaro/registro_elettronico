import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_chart.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class PeriodStatsCard extends StatelessWidget {
  final PeriodWithGradesDomainModel periodWithGradesDomainModel;

  const PeriodStatsCard({
    Key? key,
    required this.periodWithGradesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 6.0,
                    percent: (periodWithGradesDomainModel.average / 10).isNaN
                        ? 0.0
                        : periodWithGradesDomainModel.average / 10,
                    animation: true,
                    backgroundColor: GlobalUtils.isDark(context)
                        ? Colors.white
                        : Colors.grey.withOpacity(0.3),
                    animationDuration: 300,
                    center: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(periodWithGradesDomainModel.average
                          .toStringAsFixed(2)),
                    ),
                    progressColor: GlobalUtils.getColorFromAverage(
                      periodWithGradesDomainModel.average,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate('average')!,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              //color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(top: 21.0, right: 16.0),
                child: GradesChart(
                  averageSpots: periodWithGradesDomainModel.averageSpots,
                  normalSpots: periodWithGradesDomainModel.normalSpots,
                  overallObjective:
                      periodWithGradesDomainModel.overallObjective,
                  grades: periodWithGradesDomainModel.filteredGrades,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
