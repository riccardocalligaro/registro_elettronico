import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class WeekSummaryChart extends StatefulWidget {
  final List<AgendaEvent> events;
  WeekSummaryChart({Key key, @required this.events}) : super(key: key);

  @override
  _WeekSummaryChartState createState() => _WeekSummaryChartState();
}

class _WeekSummaryChartState extends State<WeekSummaryChart> {
  int _weekEvents = 0;

  @override
  void initState() {
    _getEventsSpots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Text(
            '${AppLocalizations.of(context).translate('this_week_section_title')} - ${_getEventsMessage(_weekEvents)}'),
        SizedBox(
          height: 16,
        ),
        AspectRatio(
          aspectRatio: 2.30,
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 0.0, top: 10, bottom: 12),
            child: LineChart(mainData()),
          ),
        )
      ],
    );
  }

  String _getEventsMessage(int events) {
    if (events == 0) {
      return AppLocalizations.of(context).translate('no_events').toLowerCase();
    } else if (events == 1) {
      return '$events ${AppLocalizations.of(context).translate('event').toLowerCase()}';
    } else {
      return '$events ${AppLocalizations.of(context).translate('events').toLowerCase()}';
    }
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBottomMargin: 23,
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
                    .translate('events')
                    .toLowerCase();
                if (flSpot.y == 1) {
                  text = AppLocalizations.of(context)
                      .translate('event')
                      .toLowerCase();
                }
              }

              return LineTooltipItem(
                "${flSpot.y.toStringAsFixed(0)} $text",
                TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? flSpot.bar.colors.first
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              fontSize: 12, color: Theme.of(context).textTheme.headline6.color),
          getTitles: (value) {
            if (value <= 7) {
              final locale = AppLocalizations.of(context).locale.toString();
              return DateUtils.convertSingleDayShortForDisplay(
                      DateTime.utc(2019, 9, value.toInt() + 1), locale)
                  .toUpperCase();
            } else {
              return '';
            }
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            fontSize: 11,
          ),
          getTitles: (value) {
            return value.toStringAsFixed(0);
          },
          //margin: 3,
          //reservedSize: 28,
          // margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 1,
      maxX: 6,

      // maxY: 10,
      lineBarsData: [
        LineChartBarData(
          //showingIndicators: [1, 2, 3, 4, 5, 6],
          spots: _getEventsSpots(),
          isCurved: true,
          colors: [
            Colors.red[400],
          ],
          preventCurveOverShooting: true,

          //curveSmoothness: 0.60,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
            dotColor: Colors.red,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: _getGradients(context)
                .map((color) => color.withOpacity(0.6))
                .toList(),
            gradientColorStops: [
              0.5,
              1.0,
            ],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getEventsSpots() {
    List<FlSpot> spots = [];
    DateTime today = DateTime.now();
    DateTime firstDay;

    if (today.weekday == DateTime.saturday) {
      firstDay = today.add(Duration(days: 2));
    } else if (today.weekday == DateTime.sunday) {
      firstDay = today.add(Duration(days: 1));
    } else {
      firstDay = today.subtract(Duration(days: today.weekday - 1));
    }

    DateTime dayOfWeek = DateTime.utc(today.year, today.month, firstDay.day);

    int countEvents = 0;
    for (var i = 1; i <= 6; i++) {
      final numberOfEvents = widget.events.where((e) {
        return e.begin.day == dayOfWeek.day;
      }).length;
      spots.add(FlSpot(i.toDouble(), numberOfEvents.toDouble()));
      countEvents += numberOfEvents;
      dayOfWeek = dayOfWeek.add(Duration(days: 1));
    }

    setState(() {
      _weekEvents = countEvents;
    });
    return spots;
  }

  List<Color> _getGradients(BuildContext context) {
    return [
      Colors.red[400],
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white
    ];
  }
}
