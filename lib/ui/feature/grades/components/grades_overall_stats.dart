import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_chart.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradesOverallStats extends StatelessWidget {
  final List<Grade> grades;
  final double average;
  const GradesOverallStats({
    Key key,
    @required this.grades,
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
                    animationDuration: 300,
                    center: new Text(average.toStringAsFixed(2)),
                    progressColor: GlobalUtils.getColorFromAverage(average),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child:
                        Text(AppLocalizations.of(context).translate('average')),
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
                  grades: grades
                      .where((grade) =>
                          grade.decimalValue != -1.00 ||
                          grade.cancelled == true)
                      .toList()
                        ..sort(
                          (b, a) => b.eventDate.compareTo(a.eventDate),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
