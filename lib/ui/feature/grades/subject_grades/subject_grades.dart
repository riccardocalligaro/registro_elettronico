import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/entity/subject_averages.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SubjectGradesPage extends StatefulWidget {
  final List<Grade> grades;
  final Subject subject;
  final int period;

  SubjectGradesPage(
      {Key key,
      @required this.grades,
      @required this.subject,
      @required this.period})
      : super(key: key);

  @override
  _SubjectGradesPageState createState() => _SubjectGradesPageState();
}

class _SubjectGradesPageState extends State<SubjectGradesPage> {
  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;

    List<Grade> grades;
    if (widget.period != TabsConstants.GENERALE) {
      grades = widget.grades
          .where((grade) =>
              grade.subjectId == subject.id && grade.periodPos == widget.period)
          .toList()
            ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
    } else {
      grades = widget.grades
          .where((grade) => grade.subjectId == subject.id)
          .toList()
            ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
    }

    print(grades);
    final averages =
        GradesUtils.getSubjectAveragesFromGrades(grades, subject.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(subject.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: BlocProvider.of<SubjectsBloc>(context).professors,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Professor> professors = snapshot.data ?? [];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            _getProfessorsText(
                              professors
                                  .where((professor) =>
                                      professor.subjectId == subject.id)
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                /// Pratico scritto and orale ciruclar progress widgets
                _buildAveragesCard(averages),

                /// The chart that shows the average and grades
                _buildChartCard(subject, grades),

                // Shots the progress bar of the obj and the avg
                _buildProgressBarCard(averages),

                // Last grades
                _buildLastGrades(grades),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getProfessorsText(List<Professor> professors) {
    if (professors.length > 0) {
      String professorsText = "";
      professors.forEach((prof) {
        String name = StringUtils.titleCase(prof.name);
        if (!professorsText.contains(name))
          professorsText += "${StringUtils.titleCase(prof.name)}, ";
      });
      professorsText = StringUtils.removeLastChar(professorsText);
      return professorsText;
    }
    return AppLocalizations.of(context).translate('no_professors');
  }

  Widget _buildLastGrades(List<Grade> grades) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: grades.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: GradeCard(
                grade: grades[index],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeCard(
              grade: grades[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBarCard(SubjectAverages averages) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: LinearPercentIndicator(
                lineHeight: 14.0,
                percent:
                    (averages.average / 6) > 1.0 ? 1.0 : (averages.average / 6),
                backgroundColor: Colors.grey,
                progressColor:
                    GlobalUtils.getColorFromAverage(averages.average),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Il tuo obiettivo: 6.00'),
                  Text('La tua media: ${averages.averageValue}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAveragesCard(SubjectAverages averages) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.scrittoAverage),
                  Text('Scritto'),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.oraleAverage),
                  Text('Orale'),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.praticoAverage),
                  Text('Pratico'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(Subject subject, List<Grade> grades) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(right: 21.0),
        child: GradesChart(grades: grades),
      ),
    );
  }

  Widget _buildStatsCircle(double average) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 6.0,
      percent: (average / 10).isNaN ? 0.0 : average / 10,
      animation: true,
      animationDuration: 300,
      center: new Text(
        average.isNaN ? "-" : average.toStringAsFixed(2),
      ),
      progressColor: GlobalUtils.getColorFromAverage(average),
    );
  }
}
