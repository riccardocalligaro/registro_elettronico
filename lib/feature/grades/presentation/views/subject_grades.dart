import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/presentation_constants.dart';
import 'package:registro_elettronico/core/presentation/stateful_wrapper.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/grades_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/local_grades/local_grades_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/widgets/grades_chart.dart';
import 'package:registro_elettronico/feature/professors/presentation/bloc/professors_bloc.dart';
import 'package:registro_elettronico/utils/entity/subject_averages.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

import '../../../../utils/constants/tabs_constants.dart';

class SubjectGradesPage extends StatelessWidget {
  final List<Grade> grades;
  final Subject subject;
  final int objective;
  final int period;

  const SubjectGradesPage({
    Key key,
    @required this.grades,
    @required this.subject,
    @required this.objective,
    @required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        BlocProvider.of<ProfessorsBloc>(context)
            .add(GetProfessorsForSubject(subjectId: subject.id));
        BlocProvider.of<GradesBloc>(context).add(GetGrades());
        BlocProvider.of<LocalGradesBloc>(context).add(GetLocalGrades(
          period: period,
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // brightness: Theme.of(context).brightness,
          // elevation: 0.0,
          title: Text(subject.name),
        ),
        body: BlocBuilder<GradesBloc, GradesState>(
          builder: (context, state) {
            if (state is GradesLoaded) {
              return SubjectGradesLoaded(
                grades: state.grades,
                subject: subject,
                objective: objective,
                period: period,
              );
            } else if (state is GradesError) {
              // error widget
              return Text('Error widget');
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class SubjectGradesLoaded extends StatelessWidget {
  final List<Grade> grades;
  final Subject subject;
  final int objective;
  final int period;

  const SubjectGradesLoaded({
    Key key,
    @required this.grades,
    @required this.subject,
    @required this.objective,
    @required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSortedData(),
      initialData: Tuple2(null, null),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final Tuple2 values = snapshot.data;
        if (values.value1 != null) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  _buildProfessorsCard(context),

                  /// Pratico scritto and orale ciruclar progress widgets
                  _buildAveragesCard(values.value2, context),

                  /// The chart that shows the average and grades
                  _buildChartCard(
                      subject,
                      values.value1
                          .where((g) => GradesUtils.isValidGrade(g))
                          .toList()),

                  // Shots the progress bar of the obj and the avg
                  _buildProgressBarCard(values.value2, context),

                  _buildLocalGrades(values.value2, values.value1, context),

                  // // Last grades
                  _buildLastGrades(values.value1),
                ],
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<Tuple2<List<Grade>, SubjectAverages>> getSortedData() async {
    List<Grade> updatedGrades;

    if (period != TabsConstants.GENERALE) {
      updatedGrades = grades
          .where((grade) =>
              grade.subjectId == subject.id && grade.periodPos == period)
          .toList()
            ..sort((b, a) => a.eventDate.compareTo(b.eventDate));
    } else {
      updatedGrades = grades
          .where((grade) => grade.subjectId == subject.id)
          .toList()
            ..sort((b, a) => a.eventDate.compareTo(b.eventDate));
    }

    final averages =
        GradesUtils.getSubjectAveragesFromGrades(grades, subject.id);

    return Tuple2(updatedGrades, averages);
  }

  Widget _buildLocalGrades(
    SubjectAverages averages,
    List<Grade> grades,
    BuildContext context,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                          .where((g) => g.subjectId == subject.id)
                          .toList(),
                      averages,
                      grades,
                      context);
                }

                if (state is LocalGradesError) {
                  return CustomPlaceHolder(
                    icon: Icons.error,
                    showUpdate: false,
                    text: AppLocalizations.of(context)
                        .translate('unexcepted_error_single'),
                  );
                }

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
                          cancelWidget: Text(AppLocalizations.of(context)
                              .translate('cancel')
                              .toUpperCase()),
                          initialDoubleValue: 6.0,
                        );
                      },
                    ).then(
                      (value) {
                        if (value != null) {
                          final grade = LocalGrade(
                            periodPos: period,
                            subjectId: subject.id,
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

  Widget _buildLocalGradesLoaded(
    List<LocalGrade> localGrades,
    SubjectAverages averages,
    List<Grade> grades,
    BuildContext context,
  ) {
    final newAverage = GradesUtils.getAverageFromGradesAndLocalGrades(
      localGrades: localGrades,
      grades: grades,
    );
    final difference = GradesUtils.getDifferencePercentage(
        oldAverage: averages.average, newAverage: newAverage);
    if (localGrades.isNotEmpty) {
      localGrades.sort((b, a) => a.eventDate.compareTo(b.eventDate));
      return AnimatedContainer(
        duration: Duration(milliseconds: 2000),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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

  Widget _buildProfessorsCard(BuildContext context) {
    return BlocBuilder<ProfessorsBloc, ProfessorsState>(
      builder: (context, state) {
        if (state is ProfessorsLoadSuccess) {
          String professorsText;
          if (state.professors.isNotEmpty) {
            if (PresentationConstants.isForPresentation) {
              professorsText = GlobalUtils.getMockupName();
            } else {
              professorsText = _getProfessorsText(
                  state.professors
                      .where((professor) => professor.subjectId == subject.id)
                      .toList(),
                  context);
            }
          } else {
            professorsText =
                AppLocalizations.of(context).translate('no_professors');
          }
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(professorsText ?? ''),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  String _getProfessorsText(List<Professor> professors, BuildContext context) {
    if (professors.isNotEmpty) {
      String professorsText = "";
      professors.forEach((prof) {
        String name = StringUtils.titleCase(prof.name);
        if (!professorsText.contains(name)) {
          professorsText += "${StringUtils.titleCase(prof.name)}, ";
        }
      });
      professorsText = StringUtils.removeLastChar(professorsText);
      return professorsText;
    }
    return AppLocalizations.of(context).translate('no_professors');
  }

  Widget _buildLastGrades(List<Grade> grades) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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

  Widget _buildProgressBarCard(SubjectAverages averages, BuildContext context) {
    double percent;
    if (averages.average.isNaN) {
      percent = 0.0;
    } else if (averages.average / objective > 1) {
      percent = 1.0;
    } else {
      percent = (averages.average / objective);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: LinearPercentIndicator(
                lineHeight: 14.0,
                percent: percent,
                backgroundColor: Colors.grey,
                progressColor: GlobalUtils.getColorFromAverageAndObjective(
                    averages.average, objective),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutoSizeText(
                    '${AppLocalizations.of(context).translate('your_objective')}: $objective',
                    textScaleFactor: 1.0,
                  ),
                  AutoSizeText(
                    '${AppLocalizations.of(context).translate('your_average')}: ${averages.averageValue}',
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAveragesCard(SubjectAverages averages, BuildContext context) {
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('written')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.oraleAverage),
                  SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('oral')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(averages.praticoAverage),
                  SizedBox(
                    height: 10,
                  ),
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
        child: GradesChart(
          grades: grades,
          objective: objective,
        ),
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
      center: Text(
        average.isNaN ? "-" : average.toStringAsFixed(2),
      ),
      progressColor: GlobalUtils.getColorFromAverage(average),
    );
  }

  Icon _getIconFromChange(double change) {
    if (change > 0) {
      return Icon(
        Icons.trending_up,
        color: Colors.green,
      );
    }
    if (change == 0) {
      return Icon(
        Icons.trending_flat,
      );
    }
    if (change < 0) {
      return Icon(
        Icons.trending_down,
        color: Colors.red,
      );
    }
    return Icon(Icons.trending_flat);
  }
}
