import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

import 'grades_chart.dart';

class OverallStatsCard extends StatelessWidget {
  final List<Grade> grades;
  final int objective;
  final double average;

  const OverallStatsCard({
    Key key,
    @required this.grades,
    @required this.objective,
    @required this.average,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: _getStats(context),
      ),
    );
  }

  Widget _getStats(BuildContext context) {
    List<Grade> gradesToUse = grades
        .where(
            (grade) => grade.decimalValue != -1.00 || grade.cancelled == true)
        .toList();
    gradesToUse.sort((a, b) => a.eventDate.compareTo(b.eventDate));

    return Container(
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
                    percent: (average / 10).isNaN ? 0.0 : average / 10,
                    animation: true,
                    backgroundColor: GlobalUtils.isDark(context)
                        ? Colors.white
                        : Colors.grey.withOpacity(0.3),
                    animationDuration: 300,
                    center: Text(average.toStringAsFixed(2)),
                    progressColor: GlobalUtils.getColorFromAverage(average),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context).translate('average'),
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
                  grades: gradesToUse,
                  objective: objective,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
