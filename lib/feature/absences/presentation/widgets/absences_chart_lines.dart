import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class AbsencesChartLines extends StatefulWidget {
  final Map<int, List<Absence>> absences;

  const AbsencesChartLines({
    Key key,
    @required this.absences,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AbsencesChartLinesState();
}

class AbsencesChartLinesState extends State<AbsencesChartLines> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 28.0, left: 0.0, top: 16.0),
                    child: LineChart(
                      absencesData(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData absencesData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[900].withOpacity(0.9),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                String text;
                // This also checks if the event is only one and in case changes the text to singular
                if (flSpot.barIndex == 0) {
                  text = AppLocalizations.of(context)
                      .translate('absences')
                      .toLowerCase();
                  if (flSpot.y == 1) {
                    text = AppLocalizations.of(context)
                        .translate('absence')
                        .toLowerCase();
                  }
                }
                if (flSpot.barIndex == 1) {
                  text = AppLocalizations.of(context)
                      .translate('delay')
                      .toLowerCase();
                  if (flSpot.y == 1) {
                    text = AppLocalizations.of(context)
                        .translate('late')
                        .toLowerCase();
                  }
                }

                if (flSpot.barIndex == 2) {
                  text = AppLocalizations.of(context)
                      .translate('early_exits')
                      .toLowerCase();
                  if (flSpot.y == 1) {
                    text = AppLocalizations.of(context)
                        .translate('early_exit')
                        .toLowerCase();
                  }
                }

                return LineTooltipItem(
                  "${flSpot.y.toStringAsFixed(0)} $text",
                  TextStyle(
                    color: flSpot.bar.colors.first,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            }),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) {
            return TextStyle(
              color: Colors.white,
              fontSize: 12,
            );
          },
          margin: 10,
          getTitles: (value) {
            final locale = AppLocalizations.of(context).locale.toString();
            switch (value.toInt()) {
              case 1:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 9, 1), locale)
                    .toUpperCase();
              case 2:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 10, 1), locale)
                    .toUpperCase();
              case 3:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 11, 1), locale)
                    .toUpperCase();
              case 4:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 12, 1), locale)
                    .toUpperCase();
              case 5:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 1, 1), locale)
                    .toUpperCase();
              case 6:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 2, 1), locale)
                    .toUpperCase();
              case 7:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 3, 1), locale)
                    .toUpperCase();

              case 8:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 4, 1), locale)
                    .toUpperCase();
              case 9:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 5, 1), locale)
                    .toUpperCase();
              case 10:
                return SRDateUtils.convertMonthForDisplay(
                        DateTime.utc(2019, 6, 1), locale)
                    .toUpperCase();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    LineChartBarData lineChartBarAbsences = LineChartBarData(
      spots: _getSposts(RegistroConstants.ASSENZA),
      isCurved: true,
      preventCurveOverShooting: true,
      colors: [Colors.red],
      barWidth: 6,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarRitardi = LineChartBarData(
      spots: _getSpostsDoubleCode(
          RegistroConstants.RITARDO_BREVE, RegistroConstants.RITARDO),
      isCurved: true,
      preventCurveOverShooting: true,
      colors: [Colors.blue],
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        Color(0x00aa4cfc),
      ]),
    );
    LineChartBarData lineChartBarUscite = LineChartBarData(
      spots: _getSposts(RegistroConstants.USCITA),
      isCurved: true,
      preventCurveOverShooting: true,
      colors: [
        Colors.yellow[600],
      ],
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarAbsences,
      lineChartBarRitardi,
      lineChartBarUscite,
    ];
  }

  FlSpot _getSpotForMonth(double month, String code, {String code2}) {
    final absences = widget.absences[month];
    double monthGraph;
    if (month >= 9.0 && month <= 12.0) {
      monthGraph = month - 8;
    } else {
      monthGraph = month + 4;
    }

    if (absences != null) {
      final spot = FlSpot(
        monthGraph,
        absences
            .where((absence) =>
                (absence.evtCode == code || absence.evtCode == code2 ?? '') &&
                absence.evtDate.month == month.toInt())
            .length
            .toDouble(),
      );
      return spot;
    }
    return FlSpot(monthGraph, 0.0);
  }

  List<FlSpot> _getSposts(String code) {
    return [
      _getSpotForMonth(9, code),
      _getSpotForMonth(10, code),
      _getSpotForMonth(11, code),
      _getSpotForMonth(12, code),
      _getSpotForMonth(1, code),
      _getSpotForMonth(2, code),
      _getSpotForMonth(3, code),
      _getSpotForMonth(4, code),
      _getSpotForMonth(5, code),
      _getSpotForMonth(6, code),
    ];
  }

  List<FlSpot> _getSpostsDoubleCode(String code1, String code2) {
    return [
      _getSpotForMonth(9, code1, code2: code2),
      _getSpotForMonth(10, code1, code2: code2),
      _getSpotForMonth(11, code1, code2: code2),
      _getSpotForMonth(12, code1, code2: code2),
      _getSpotForMonth(1, code1, code2: code2),
      _getSpotForMonth(2, code1, code2: code2),
      _getSpotForMonth(3, code1, code2: code2),
      _getSpotForMonth(4, code1, code2: code2),
      _getSpotForMonth(5, code1, code2: code2),
      _getSpotForMonth(6, code1, code2: code2),
    ];
  }
}
