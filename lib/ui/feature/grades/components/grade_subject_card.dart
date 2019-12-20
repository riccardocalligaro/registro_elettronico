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
    final averages =
        GlobalUtils.getSubjectAveragesFromGrades(grades, subject.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),

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
              backgroundColor: Colors.white,
              animation: true,
              animationDuration: 300,
              center: new Text(averages.average.toStringAsFixed(2)),
              progressColor: GlobalUtils.getColorFromAverage(averages.average),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                subject.name.length < 20
                    ? subject.name
                    : GlobalUtils.reduceSubjectTitle(subject.name),
                style: TextStyle(color: Colors.white),
              ),
              Text(averages.oraleAverage.toStringAsFixed(2)),
              Text(averages.praticoAverage.toStringAsFixed(2)),
              Text(averages.scrittoAverage.toStringAsFixed(2)),
              Container(
                height: 15,
                decoration: BoxDecoration(color: Colors.green),
                child: Text('Devi prendere almeno 10', style: TextStyle(color: Colors.white, fontSize: 9),),
              )
            ],
          )
        ],
      ),
    );
  }
}
