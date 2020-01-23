import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class WeekSummaryChart extends StatefulWidget {
  final List<AgendaEvent> events;
  WeekSummaryChart({Key key, @required this.events}) : super(key: key);

  @override
  _WeekSummaryChartState createState() => _WeekSummaryChartState();
}

class _WeekSummaryChartState extends State<WeekSummaryChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.30,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18.0, left: 18.0, top: 24, bottom: 12),
        child: LineChart(mainData()),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
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
            fontSize: 12,
          ),
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
          showTitles: false,
          textStyle: TextStyle(
            fontSize: 12,
          ),
          getTitles: (value) {
            return value.toStringAsFixed(0);
          },
          reservedSize: 28,
          margin: 12,
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

          // curveSmoothness: 0.20,
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
    DateTime firstDay = today.subtract(Duration(days: today.weekday - 1));

    DateTime dayOfWeek = DateTime.utc(today.year, today.month, firstDay.day);

    for (var i = 1; i <= 6; i++) {
      final numberOfEvents = widget.events.where((e) {
        return e.begin.day == dayOfWeek.day;
      }).length;
      spots.add(FlSpot(i.toDouble(), numberOfEvents.toDouble()));
      dayOfWeek = dayOfWeek.add(Duration(days: 1));
    }
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
