import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/grades/presentation/widgets/grades_chart.dart';
import 'package:registro_elettronico/feature/stats/data/model/student_report.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/stats_bloc.dart';
import 'charts/grades_bar_chart.dart';
import 'charts/grades_pie_chart.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  ScreenshotController screenshotController = ScreenshotController();
  int objective;

  @override
  void initState() {
    super.initState();
    restore();
    BlocProvider.of<StatsBloc>(context).add(GetStudentStats());
  }

  void restore() async {
    SharedPreferences _prefs = sl();
    objective = _prefs.getInt(PrefsConstants.OVERALL_OBJECTIVE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context).translate('statistics'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final directory = (await getApplicationDocumentsDirectory()).path;
              String fileName = AppLocalizations.of(context)
                      .translate('statistics')
                      .toLowerCase() +
                  DateTime.now().toIso8601String();

              var path = '$directory/$fileName.png';

              await screenshotController
                  .capture(
                path: path,
                pixelRatio: 2,
              )
                  .then((File image) async {
                var bytes = await image.readAsBytes();
                await Share.file(
                  AppLocalizations.of(context).translate('statistics'),
                  '$fileName.png',
                  bytes.buffer.asUint8List(),
                  'image/png',
                  text:
                      '${AppLocalizations.of(context).translate('statistics')} ${DateUtils.convertDateLocaleDashboard(DateTime.now(), AppLocalizations.of(context).locale.toString())}',
                );
              }).catchError((onError) {
                FLog.info(text: 'Coudlnt create stats image file for sharing');
              });
            },
          )
        ],
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
    return SingleChildScrollView(
      child: Screenshot(
        controller: screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // shrinkWrap: true,
            // padding: EdgeInsets.all(8.0),
            children: <Widget>[
              _buildOverallStatsCard(report: studentReport),

              _buildAverageChart(
                grades: studentReport.grades,
                objective: objective,
              ),

              _buildSecondRowGraphs(report: studentReport),

              _buildThirdRowCard(report: studentReport),

              //_buildFourthRowCard(report: studentReport),
            ],
          ),
        ),
      ),
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
                  AutoSizeText(
                    AppLocalizations.of(context)
                        .translate('days_to_school_end')
                        .replaceAll(
                            '{days}',
                            report.timeRemainingToSchoolFinish.inDays
                                .toString()),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context)
                        .translate('sufficienti_subjects')
                        .replaceAll('{number}',
                            report.sufficientiSubjectsCount.toString()),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context)
                        .translate('insufficient_subjects')
                        .replaceAll('{number}', insufficientiTotal.toString()),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('best_term')
                      .replaceAll('{number}',
                          '${report.mostProfitablePeriod.periodIndex}° ${AppLocalizations.of(context).translate('term')}')),
                  SizedBox(
                    height: 4,
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context)
                        .translate('skipped_tests')
                        .replaceAll(
                          '{number}',
                          report.skippedTestsForAbsences.toString(),
                        ),
                    maxLines: 2,
                  )
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
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            '${AppLocalizations.of(context).translate('score')}: ${report.score.toStringAsFixed(2)}'),
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

  Widget _buildAverageChart({
    @required List<Grade> grades,
    int objective,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)
                  .translate('stats_timeline_graph_average'),
            ),
            GradesChart(
              showAverageFirst: true,
              grades: grades,
              objective: objective,
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
                    AutoSizeText(
                      AppLocalizations.of(context).translate('averages'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(report.firstTermAverage.isNaN
                              ? '-'
                              : report.firstTermAverage.toStringAsFixed(2)),
                          AutoSizeText(
                            'Q1',
                            style: TextStyle(fontSize: 12),
                            textScaleFactor: 1.0,
                          )
                        ],
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
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(report.secondTermAverage.isNaN
                              ? '-'
                              : report.secondTermAverage.toStringAsFixed(2)),
                          Text(
                            'Q2',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
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
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(report.average.isNaN
                              ? '-'
                              : report.average.toStringAsFixed(2)),
                          Text(
                            AppLocalizations.of(context).translate('year'),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
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
