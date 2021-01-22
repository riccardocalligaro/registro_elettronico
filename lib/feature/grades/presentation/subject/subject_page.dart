import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/subject_data_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loading.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_chart.dart';
import 'package:registro_elettronico/feature/grades/presentation/subject/local_watcher/local_grades_watcher_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/subject/pageset/subject_grades_pageset_bloc.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SubjectGradesPage extends StatefulWidget {
  final PeriodGradeDomainModel periodGradeDomainModel;
  final int periodPos;

  SubjectGradesPage({
    Key key,
    @required this.periodGradeDomainModel,
    @required this.periodPos,
  }) : super(key: key);

  @override
  _SubjectGradesPageState createState() => _SubjectGradesPageState();
}

class _SubjectGradesPageState extends State<SubjectGradesPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SubjectGradesPagesetBloc>(context).add(
      GetSubjectGradesPageset(
        periodGradeDomainModel: widget.periodGradeDomainModel,
      ),
    );

    BlocProvider.of<LocalGradesWatcherBloc>(context).add(
      LocalGradesWatchAllStarted(
        subjectId: widget.periodGradeDomainModel.subject.id,
        periodPos: widget.periodPos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.periodGradeDomainModel.subject.name),
      ),
      body: BlocBuilder<SubjectGradesPagesetBloc, SubjectGradesPagesetState>(
        builder: (context, state) {
          if (state is SubjectGradesPagesetLoaded) {
            return _SubjectGradesPage(
              state.subjectDataDomainModel,
              periodPos: widget.periodPos,
            );
          } else if (state is SubjectGradesPagesetFailure) {
            return GradesFailure(failure: state.failure);
          }

          return GradesLoading();
        },
      ),
    );
  }
}

class _SubjectGradesPage extends StatelessWidget {
  final SubjectDataDomainModel data;
  final int periodPos;

  const _SubjectGradesPage(
    this.data, {
    Key key,
    @required this.periodPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _ProfessorsCard(professors: data.professors),
        const SizedBox(
          height: 8,
        ),
        _AveragesCard(subjectAveragesDomainModel: data.averages),
        const SizedBox(
          height: 8,
        ),
        _GradesChart(data: data),
        const SizedBox(
          height: 8,
        ),
        _ProgressBarCard(
          averages: data.averages,
          objective: data.data.objective,
        ),
        const SizedBox(
          height: 8,
        ),
        _LocalGrades(
          grades: data.data.grades,
          oldAverage: data.data.average,
          subjectId: data.data.subject.id,
          peridodPos: periodPos,
        ),
        const SizedBox(
          height: 8,
        ),
        _LastGrades(
          grades: data.data.grades,
        )
      ],
    );
  }
}

class _ProfessorsCard extends StatelessWidget {
  final List<ProfessorDomainModel> professors;

  const _ProfessorsCard({
    Key key,
    @required this.professors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            _getProfessorsText(professors, context),
          ),
        ),
      ),
    );
  }

  String _getProfessorsText(
    List<ProfessorDomainModel> professors,
    BuildContext context,
  ) {
    if (professors.isNotEmpty) {
      String professorsText = '';
      professors.forEach((prof) {
        String name = StringUtils.titleCase(prof.name);
        if (!professorsText.contains(name)) {
          professorsText += '${StringUtils.titleCase(prof.name)}, ';
        }
      });
      professorsText = StringUtils.removeLastChar(professorsText);
      return professorsText;
    }
    return AppLocalizations.of(context).translate('no_professors');
  }
}

class _AveragesCard extends StatelessWidget {
  final SubjectAveragesDomainModel subjectAveragesDomainModel;

  const _AveragesCard({
    Key key,
    @required this.subjectAveragesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildStatsCircle(subjectAveragesDomainModel.scrittoAverage),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('written')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(subjectAveragesDomainModel.oraleAverage),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('oral')),
                ],
              ),
              Column(
                children: <Widget>[
                  _buildStatsCircle(subjectAveragesDomainModel.praticoAverage),
                  const SizedBox(
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
}

class _GradesChart extends StatelessWidget {
  final SubjectDataDomainModel data;

  const _GradesChart({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(right: 21.0),
        child: GradesChart(
          grades: data.data.grades,
          overallObjective: data.data.objective,
          normalSpots: data.normalSpots,
          averageSpots: data.averageSpots,
        ),
      ),
    );
  }
}

class _ProgressBarCard extends StatelessWidget {
  final SubjectAveragesDomainModel averages;
  final int objective;

  const _ProgressBarCard({
    Key key,
    @required this.averages,
    @required this.objective,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percent;
    if (averages.average.isNaN) {
      percent = 0.0;
    } else if (averages.average / objective > 1) {
      percent = 1.0;
    } else {
      percent = (averages.average / objective);
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: LinearPercentIndicator(
                lineHeight: 14.0,
                percent: percent,
                backgroundColor: Colors.grey,
                progressColor: GlobalUtils.getColorFromAverageAndObjective(
                  averages.average,
                  objective,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${AppLocalizations.of(context).translate('your_objective')}: $objective',
                    textScaleFactor: 1.0,
                  ),
                  Text(
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
}

class _LocalGrades extends StatelessWidget {
  final List<GradeDomainModel> grades;
  final double oldAverage;
  final int peridodPos;
  final int subjectId;

  const _LocalGrades({
    Key key,
    @required this.grades,
    @required this.oldAverage,
    @required this.peridodPos,
    @required this.subjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalGradesWatcherBloc, LocalGradesWatcherState>(
      builder: (context, state) {
        if (state is LocalGradesWatcherLoadSuccess) {
          final newAverage = _getNewAverage(
            grades: grades,
            localGrades: state.grades,
          );

          final difference = _averagesDifference(
            oldAverage: oldAverage,
            newAverage: newAverage,
          );

          final localGrades = state.grades;

          return Card(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.timeline),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(newAverage.toStringAsFixed(2)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          _iconFromChange(difference, context),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(difference.toStringAsFixed(2)),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(),
                if (localGrades.isNotEmpty)
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.grades.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: _iconFromChange(
                          localGrades[index].decimalValue - oldAverage,
                          context,
                        ),
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
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('delete')
                                          .toUpperCase(),
                                    ),
                                    onPressed: () async {
                                      final GradesRepository gradesRepository =
                                          sl();
                                      final res = await gradesRepository
                                          .deleteLocalGrade(
                                              gradeDomainModel:
                                                  localGrades[index]);

                                      if (res.isLeft()) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(context)
                                                  .translate('error_emoji'),
                                            ),
                                          ),
                                        );
                                      }

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
                if (localGrades.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
                    child: Column(
                      children: [
                        Icon(Icons.timeline, color: Colors.grey),
                        Text(
                          AppLocalizations.of(context).translate('no_grades'),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
                        )
                      ],
                    ),
                  ),
                ButtonBar(
                  buttonPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('add')
                            .toUpperCase(),
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
                          (value) async {
                            if (value != null) {
                              final gradeToInsert = GradeDomainModel(
                                periodPos: peridodPos,
                                subjectId: subjectId,
                                eventDate: DateTime.now(),
                                decimalValue: value,
                                cancelled: false,
                                displayValue: value.toString(),
                                underlined: false,
                              );
                              final GradesRepository gradesRepository = sl();
                              final res = await gradesRepository.addLocalGrade(
                                  gradeDomainModel: gradeToInsert);

                              if (res.isLeft()) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context)
                                          .translate('error_emoji'),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  double _getNewAverage({
    @required List<GradeDomainModel> grades,
    @required List<GradeDomainModel> localGrades,
  }) {
    double sum = 0;
    int count = 0;
    grades.forEach((g) {
      if (g.decimalValue != -1.0) {
        sum += g.decimalValue;
        count++;
      }
    });

    localGrades.forEach((g) {
      if (g.decimalValue != -1.0) {
        sum += g.decimalValue;
        count++;
      }
    });

    return sum / count;
  }

  double _averagesDifference({
    @required double oldAverage,
    @required double newAverage,
  }) {
    if (newAverage > 0 && oldAverage > 0) {
      return (newAverage - oldAverage) / oldAverage * 10;
    }
    return 0.0;
  }

  Icon _iconFromChange(double change, BuildContext context) {
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

class _LastGrades extends StatelessWidget {
  final List<GradeDomainModel> grades;

  const _LastGrades({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: grades.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GradeCard(
            grade: grades[index],
            fromSubjectGrades: true,
          ),
        );
      },
    );
  }
}
