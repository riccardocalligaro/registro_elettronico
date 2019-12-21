import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_chart.dart';
import 'package:registro_elettronico/utils/entity/overall_stats.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradesOverallStats extends StatelessWidget {
  final OverallStats stats;
  final List<Grade> grades;
  const GradesOverallStats(
      {Key key, @required this.stats, @required this.grades})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 20.0,
              spreadRadius: 1.0,
              offset: Offset(
                1.0,
                0.0,
              ),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: _getStats(),
        ),
      ),
    );
  }

  Widget _getStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 6.0,
              percent: (stats.average / 10).isNaN ? 0.0 : stats.average / 10,
              animation: true,
              animationDuration: 300,
              center: new Text(stats.average.toStringAsFixed(2)),
              progressColor: GlobalUtils.getColorFromAverage(stats.average),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Average'),
            )
          ],
        ),
        Expanded(
          child: GradesChart(
              grades: grades
                  .where((grade) =>
                      grade.decimalValue != -1.00 || grade.cancelled == true)
                  .toList()
                    ..sort((b, a) => b.eventDate.compareTo(a.eventDate))),
        ),
        // Wrap(
        //   alignment: WrapAlignment.center,
        //   crossAxisAlignment: WrapCrossAlignment.start,
        //   direction: Axis.vertical,
        //   children: <Widget>[
        //     Text('Sufficienze: ${stats.sufficienze}',
        //         style: TextStyle(fontSize: 15)),
        //     Text(
        //       'Insufficienze: ${stats.insufficienze}',
        //       style: TextStyle(fontSize: 15),
        //     ),
        //     Text('Voto minimo: ${stats.votoMin}',
        //         style: TextStyle(fontSize: 15)),
        //     Text('Voto massimo: ${stats.votoMin}',
        //         style: TextStyle(fontSize: 15)),
        //     Text('Voto max: ${stats.bestSubject.name}',
        //         style: TextStyle(fontSize: 15)),
        //     Text(
        //         'Miglior materia:  ${GlobalUtils.reduceSubjectTitle(stats.worstSubject.name)}',
        //         style: TextStyle(fontSize: 15)),
        //     Text('Crediti:  ${stats.votoMax}', style: TextStyle(fontSize: 15)),
        //   ],
        // ),
      ],
    );
  }
}
