import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeSubjectCard extends StatelessWidget {
  final Subject subject;
  final List<Grade> grades;
  const GradeSubjectCard(
      {Key key, @required this.grades, @required this.subject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final averages = GlobalUtils.getSubjectAveragesFromGrades(grades);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          //color: Colors.red,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 6.0,
                  percent: averages.average / 10,
                  animation: true,
                  animationDuration: 300,
                  center: new Text(averages.average.toStringAsFixed(2)),
                  progressColor:
                      GlobalUtils.getColorFromGrade(averages.average),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(subject.name.length < 20
                      ? subject.name
                      : GlobalUtils.reduceSubjectTitle(subject.name)),
                  Text(averages.oraleAverage.toStringAsFixed(2)),
                  Text(averages.praticoAverage.toStringAsFixed(2)),
                  Text(averages.scrittoAverage.toStringAsFixed(2)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
