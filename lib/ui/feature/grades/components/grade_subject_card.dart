import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/pages/subject_grades.dart';
import 'package:registro_elettronico/ui/feature/settings/components/general/general_objective_settings_dialog.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradeSubjectCard extends StatefulWidget {
  final Subject subject;
  final List<Grade> grades;
  final int objective;
  final int period;

  const GradeSubjectCard({
    Key key,
    @required this.grades,
    @required this.subject,
    @required this.objective,
    @required this.period,
  }) : super(key: key);

  @override
  _GradeSubjectCardState createState() => _GradeSubjectCardState();
}

class _GradeSubjectCardState extends State<GradeSubjectCard> {
  @override
  Widget build(BuildContext context) {
    final average = GradesUtils.getAverage(widget.subject.id, widget.grades);
    int objective = widget.objective;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubjectGradesPage(
                subject: widget.subject,
                grades: widget.grades,
                objective: widget.objective,
                period: widget.period,
              ),
            ),
          );
        },
        onLongPress: () async {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              children: <Widget>[
                GeneralObjectiveSettingsDialog(
                  objective: objective,
                )
              ],
            ),
          ).then((value) async {
            if (value != null) {
              SharedPreferences pres = Injector.appInstance.getDependency();
              pres.setInt('${widget.subject.id}_objective', value);
              BlocProvider.of<SubjectsGradesBloc>(context)
                  .add(GetGradesAndSubjects());
            }
          });
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
                  percent: _getPercentAverage(average),
                  backgroundColor: Colors.white,
                  animation: true,
                  animationDuration: 300,
                  center: Text(average <= 0 ? '-' : average.toStringAsFixed(2)),
                  progressColor: _getColorFromAverage(average),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        widget.subject.name.length < 20
                            ? widget.subject.name
                            : GlobalUtils.reduceSubjectTitle(widget.subject.name),
                        maxLines: 1,
                      ),
                      Text(
                        GradesUtils.getGradeMessage(
                            objective.toDouble(),
                            average,
                            widget.grades
                                .where((grade) =>
                                    grade.subjectId == widget.subject.id &&
                                    GradesUtils.isValidGrade(grade))
                                .toList()
                                .length,
                            context),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .body1
                            .copyWith(fontSize: 12),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _getPercentAverage(double average) {
    if (average == -1) return 1.0;
    return average / 10;
  }

  Color _getColorFromAverage(double value) {
    if (value == -1.00) {
      return Colors.white;
    } else if (value == 0.00) {
      return Colors.blue;
    } else if (value >= 6) {
      return Colors.green;
    } else if (value >= 5.5 && value < 6) {
      return Colors.yellow[700];
    } else {
      return Colors.red;
    }
  }
}
