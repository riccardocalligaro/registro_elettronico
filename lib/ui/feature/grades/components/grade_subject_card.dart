import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/feature/grades/subject_grades/subject_grades.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';

class GradeSubjectCard extends StatelessWidget {
  final Subject subject;
  final List<Grade> grades;
  final int period;
  const GradeSubjectCard(
      {Key key,
      @required this.grades,
      @required this.subject,
      @required this.period})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final average = GradesUtils.getAverage(subject.id, grades);
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubjectGradesPage(
                subject: subject,
                grades: grades,
                period: period,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 6.0,
                  percent: average / 10,
                  backgroundColor: Colors.white,
                  animation: true,
                  animationDuration: 300,
                  center: new Text(average.toStringAsFixed(2)),
                  progressColor: GlobalUtils.getColorFromAverage(average),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.name.length < 20
                          ? subject.name
                          : GlobalUtils.reduceSubjectTitle(subject.name),
                    ),
                    Text(
                      GradesUtils.getGradeMessage(
                          6.0,
                          average,
                          grades
                              .where((grade) => grade.subjectId == subject.id)
                              .toList()
                              .length,
                          context),
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body1
                          .copyWith(fontSize: 12),
                    )
                    // Text(oraleAverage.toStringAsFixed(2)),
                    // Text(praticoAverage.toStringAsFixed(2)),
                    // Text(scrittoAverage.toStringAsFixed(2)),
                    // Container(
                    //   height: 15,
                    //   decoration: BoxDecoration(color: Colors.green),
                    //   child: Text(
                    //     'Devi prendere almeno 10',
                    //     style: TextStyle(color: Colors.white, fontSize: 9),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
