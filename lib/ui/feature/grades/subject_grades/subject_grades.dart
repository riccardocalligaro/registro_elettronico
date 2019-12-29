import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/local_grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/local_grades/local_grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/local_grades/local_grades_state.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/entity/subject_averages.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _objective = 6;
  double _currentPickerValue = 6.0;

  @override
  void initState() {
    BlocProvider.of<LocalGradesBloc>(context)
        .add(GetLocalGrades(period: widget.period));
    restore();
    super.initState();
  }

  void restore() async {
    Logger log = Logger();
    log.v(_objective);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _objective = (preferences.getInt('objective_${widget.subject.id}') ?? 6);
    });
    log.i(_objective);
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;

    List<Grade> grades;
    if (widget.period != TabsConstants.GENERALE) {
      grades = widget.grades
          .where((grade) =>
              grade.subjectId == subject.id && grade.periodPos == widget.period)
          .toList()
            ..sort((b, a) => a.eventDate.compareTo(b.eventDate));
    } else {
      grades = widget.grades
          .where((grade) => grade.subjectId == subject.id)
          .toList()
            ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
    }

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
                _buildProfessorsCard(),

                /// Pratico scritto and orale ciruclar progress widgets
                _buildAveragesCard(averages),

                /// The chart that shows the average and grades
                _buildChartCard(subject, grades),

                // Shots the progress bar of the obj and the avg
                _buildProgressBarCard(averages),

                _buildLocalGrades(averages, grades),

                // Last grades
                _buildLastGrades(grades),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocalGrades(SubjectAverages averages, List<Grade> grades) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         child: Expanded(
            //           child: Text('Your grades'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            BlocBuilder<LocalGradesBloc, LocalGradesState>(
              builder: (context, state) {
                if (state is LocalGradesError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LocalGradesLoaded) {
                  return _buildLocalGradesLoaded(
                      state.localGrades
                          .where((g) => g.subjectId == widget.subject.id)
                          .toList(),
                      averages,
                      grades);
                }

                if (state is LocalGradesError) {}

                return Container();
              },
            ),
            ButtonBar(
              //buttonPadding: EdgeInsets.zero,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).translate('add').toUpperCase(),
                  ),
                  onPressed: () {
                    showDialog<double>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.decimal(
                          minValue: 1,
                          maxValue: 10,
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('pick_a_grade'),
                          ),
                        cancelWidget: Text(AppLocalizations.of(context).translate('cancel').toUpperCase()),
                          initialDoubleValue: _currentPickerValue,
                        );
                      },
                    ).then(
                      (value) {
                        if (value != null) {
                          final grade = LocalGrade(
                            periodPos: widget.period,
                            subjectId: widget.subject.id,
                            id: GlobalUtils.getRandomNumber(),
                            eventDate: DateTime.now(),
                            decimalValue: value,
                            cancelled: false,
                            displayValue: value.toString(),
                            underlined: false,
                          );
                          BlocProvider.of<LocalGradesBloc>(context).add(
                            AddLocalGrade(
                              localGrade: grade,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // child:
    );
  }

  Widget _buildLocalGradesLoaded(List<LocalGrade> localGrades,
      SubjectAverages averages, List<Grade> grades) {
    final newAverage = GradesUtils.getAverageFromGradesAndLocalGrades(
      localGrades: localGrades,
      grades: grades,
    );
    final difference = GradesUtils.getDifferencePercentage(
        oldAverage: averages.average, newAverage: newAverage);
    if (localGrades.length > 0) {
      localGrades.sort((b, a) => a.eventDate.compareTo(b.eventDate));
      return AnimatedContainer(
        duration: Duration(milliseconds: 2000),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.timeline),
                      SizedBox(
                        width: 8,
                      ),
                      Text(newAverage.toStringAsFixed(2)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _getIconFromChange(difference),
                      SizedBox(
                        width: 8,
                      ),
                      Text(difference.toStringAsFixed(2)),
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            //Placeholder()
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: localGrades.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _getIconFromChange(
                      localGrades[index].decimalValue - averages.average),
                  title: Text(
                    localGrades[index].displayValue,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('sure_to_delete_it'),
                          ),
                          content: Text(
                            AppLocalizations.of(context)
                                .translate('local_grade_will_be_removed'),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('cancel')
                                    .toUpperCase(),
                              ),
                              onPressed: () {},
                            ),
                            FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('delete')
                                    .toUpperCase(),
                              ),
                              onPressed: () {
                                BlocProvider.of<LocalGradesBloc>(context).add(
                                    DeleteLocalGrade(
                                        localGrade: localGrades[index]));
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
      child: CustomPlaceHolder(
        icon: Icons.timeline,
        text: AppLocalizations.of(context).translate('no_local_grades'),
        showUpdate: false,
      ),
    );
  }

  Widget _buildProfessorsCard() {
    return StreamBuilder(
      stream: BlocProvider.of<SubjectsBloc>(context).professors,
      initialData: List<Professor>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Professor> professors = snapshot.data ?? List<Professor>();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                _getProfessorsText(
                  professors
                      .where((professor) =>
                          professor.subjectId == widget.subject.id)
                      .toList(),
                ),
              ),
            ),
          ),
        );
      },
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
          return Padding(
            padding: index == 0
                ? EdgeInsets.only(top: 2.0, bottom: 8.0)
                : EdgeInsets.only(bottom: 8.0),
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
                percent: (averages.average / _objective) > 1.0
                    ? 1.0
                    : (averages.average / _objective),
                backgroundColor: Colors.grey,
                progressColor: GlobalUtils.getColorFromAverageAndObjective(
                    averages.average, _objective),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${AppLocalizations.of(context).translate('your_objective')}: $_objective'),
                  Text(
                      '${AppLocalizations.of(context).translate('your_average')}: ${averages.averageValue}'),
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
                  Text(AppLocalizations.of(context).translate('written')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.oraleAverage),
                  Text(AppLocalizations.of(context).translate('oral')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.praticoAverage),
                  Text(AppLocalizations.of(context).translate('pratico')),
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

  Icon _getIconFromChange(double change) {
    if (change > 0)
      return Icon(
        Icons.trending_up,
        color: Colors.green,
      );
    if (change == 0)
      return Icon(
        Icons.trending_flat,
      );
    if (change < 0)
      return Icon(
        Icons.trending_down,
        color: Colors.red,
      );
  }
}
