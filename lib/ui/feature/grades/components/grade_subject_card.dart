import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              SharedPreferences pres = await SharedPreferences.getInstance();
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
                  percent: average.isNaN ? 1 : average / 10,
                  backgroundColor: Colors.white,
                  animation: true,
                  animationDuration: 300,
                  center:
                      Text(average.isNaN ? '-' : average.toStringAsFixed(2)),
                  progressColor: GlobalUtils.getColorFromAverage(average),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.subject.name.length < 20
                          ? widget.subject.name
                          : GlobalUtils.reduceSubjectTitle(widget.subject.name),
                    ),
                    Text(
                      GradesUtils.getGradeMessage(
                          objective.toDouble(),
                          average,
                          widget.grades
                              .where((grade) =>
                                  grade.subjectId == widget.subject.id)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
