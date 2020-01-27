import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/domain/entity/student_report.dart';
import 'package:registro_elettronico/ui/bloc/stats/bloc.dart';
import 'package:registro_elettronico/ui/feature/stats/charts/grades_bar_chart.dart';
import 'package:registro_elettronico/ui/feature/stats/charts/grades_pie_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatsBloc>(context).add(GetStudentStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('statitics'),
        ),
      ),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StatsLoadError) {
            return _buildErrorState();
          } else if (state is StatsLoadSuccess) {
            return _buildSuccess(state.studentReport);
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return CustomPlaceHolder(
      icon: Icons.error,
      text: AppLocalizations.of(context).translate('unexcepted_error_single'),
      showUpdate: true,
      onTap: () {
        BlocProvider.of<StatsBloc>(context).add(UpdateStudentStats());
        BlocProvider.of<StatsBloc>(context).add(GetStudentStats());
      },
    );
  }

  Widget _buildSuccess(StudentReport studentReport) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        _buildOverallStatsCard(report: studentReport),
        _buildSecondRowGraphs(report: studentReport),
        _buildThirdRowCard(report: studentReport),
        //_buildFourthRowCard(report: studentReport),
      ],
    );
  }

  Widget _buildOverallStatsCard({@required StudentReport report}) {
    final insufficientiTotal = report.insufficientiSubjectsCount +
        report.nearlySufficientiSubjectsCount;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context)
                      .translate('general_average')
                      .replaceAll(
                          '{average}', report.average.toStringAsFixed(2))),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('credits').replaceAll(
                        '{credits}',
                        report.schoolCredits > 0
                            ? '${report.schoolCredits}-${report.schoolCredits + 1}'
                            : AppLocalizations.of(context)
                                .translate('no_credits')),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('best_subject')
                      .replaceAll(
                          '{subject}', report.bestSubject.name.toLowerCase())),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('worst_subject')
                      .replaceAll(
                          '{subject}', report.worstSubject.name.toLowerCase())),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('days_to_school_end')
                      .replaceAll(
                          '{days}',
                          report.timeRemainingToSchoolFinish.inDays
                              .toString())),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('sufficienti_subjects')
                      .replaceAll('{number}',
                          report.sufficientiSubjectsCount.toString())),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('insufficient_subjects')
                      .replaceAll('{number}', insufficientiTotal.toString())),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('best_term')
                      .replaceAll('{number}',
                          '${report.mostProfitablePeriod.periodIndex}° ${AppLocalizations.of(context).translate('term')}')),
                ],
              ),
            ),
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 6.0,
              percent: report.score.isNaN ? 1 : report.score / 100,
              backgroundColor: Colors.white,
              animation: true,
              animationDuration: 300,
              center: IconButton(
                icon: Icon(Icons.info),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            '${AppLocalizations.of(context).translate('score')}: ${report.score}'),
                        content: Text(AppLocalizations.of(context)
                            .translate('score_description')),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              AppLocalizations.of(context).translate('ok'),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              progressColor: GlobalUtils.getColorFromAverage(report.average),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSecondRowGraphs({
    @required StudentReport report,
  }) {
    return Container(
      height: 315,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: GradesPieChart(
              sufficientiCount: report.sufficienzeCount,
              insufficientiCount: report.insufficienzeGraviCount,
              nearlySufficientiCount: report.insufficienzeLieviCount,
              totalGrades: report.totalGrades,
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(AppLocalizations.of(context).translate('averages')),
                    SizedBox(
                      height: 10,
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 6.0,
                      percent: report.firstTermAverage.isNaN
                          ? 1
                          : report.firstTermAverage / 10,
                      backgroundColor: Colors.white,
                      animation: true,
                      animationDuration: 300,
                      center: Text(
                        'Q1',
                        style: TextStyle(fontSize: 12),
                      ),
                      progressColor: GlobalUtils.getColorFromAverage(
                        report.firstTermAverage,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 6.0,
                      percent: report.secondTermAverage.isNaN
                          ? 1
                          : report.secondTermAverage / 10,
                      backgroundColor: Colors.white,
                      animation: true,
                      animationDuration: 300,
                      center: Text(
                        'Q2',
                        style: TextStyle(fontSize: 12),
                      ),
                      progressColor: GlobalUtils.getColorFromAverage(
                          report.secondTermAverage),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 6.0,
                      percent: report.average.isNaN ? 1 : report.average / 10,
                      backgroundColor: Colors.white,
                      animation: true,
                      animationDuration: 300,
                      center: Text(
                        AppLocalizations.of(context).translate('year'),
                        style: TextStyle(fontSize: 12),
                      ),
                      progressColor: GlobalUtils.getColorFromAverage(
                        report.average,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThirdRowCard({
    @required StudentReport report,
  }) {
    return GradesBarChart(
      grades: report.grades..sort((a, b) => a.eventDate.compareTo(b.eventDate)),
    );
  }

  // Widget _buildFourthRowCard({
  //   @required StudentReport report,
  // }) {
  //   final insufficientiTotal = report.insufficientiSubjectsCount +
  //       report.nearlySufficientiSubjectsCount;
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text('Media eventi per giorno'),
  //           // WeekEventsChart(
  //           //   events: report.agendaEvents,
  //           // )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
