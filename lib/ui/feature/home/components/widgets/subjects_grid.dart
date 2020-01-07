import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/feature/grades/subject_grades/subject_grades.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_painter.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';

class SubjectsGrid extends StatelessWidget {
  final List<Subject> subjects;
  final List<Grade> grades;
  final int period;

  const SubjectsGrid({
    Key key,
    @required this.subjects,
    @required this.grades,
    @required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5.0,
        shrinkWrap: true,
        children: List.generate(subjects.length, (index) {
          final subject = subjects[index];
          double average;
          if (period != TabsConstants.GENERALE) {
            average = GradesUtils.getAverage(subject.id,
                grades.where((g) => g.periodPos == period).toList());
          } else {
            average = GradesUtils.getAverage(subject.id, grades);
          }

          return GridTile(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: new Container(
                      height: 50.0,
                      width: 50.0,
                      child: new CustomPaint(
                        foregroundPainter: GradePainer(
                            lineColor: Colors.white,
                            completeColor: _getColorForAverage(average),
                            completePercent: average.isNaN ? 0 : average * 10,
                            width: 4.0),
                        child: Center(
                          child: ClipOval(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => SubjectGradesPage(
                                      subject: subject,
                                      grades: grades,
                                      period: period,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                padding: const EdgeInsets.all(13.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: GlobalUtils.getIconFromSubject(
                                  subject.name,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      subject.name.length > 14
                          ? GlobalUtils.reduceSubjectGridTitle(subject.name)
                          : subject.name,
                      style: TextStyle(fontSize: 9),
                    ),
                  )
                ]),
          );
        }),
      ),
    );
  }

  MaterialColor _getColorForAverage(double average) {
    if (average >= 6) {
      return Colors.green;
    } else if (average >= 5.5 && average < 6) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
