import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class NextTestsChart extends StatefulWidget {
  final List<AgendaEvent> events;
  NextTestsChart({Key key, @required this.events}) : super(key: key);

  @override
  _NextTestsChartState createState() => _NextTestsChartState();
}

class _NextTestsChartState extends State<NextTestsChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                //color: const Color(0xff232d37)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(mainData()),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0.75,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: const Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            final locale = AppLocalizations.of(context).locale.toString();
            switch (value.toInt()) {
              case 1:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 2), locale)
                    .toUpperCase();
              case 2:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 3), locale)
                    .toUpperCase();
              case 3:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 4), locale)
                    .toUpperCase();
              case 4:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 5), locale)
                    .toUpperCase();
              case 5:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 6), locale)
                    .toUpperCase();
              case 6:
                return DateUtils.convertSingleDayShortForDisplay(
                        DateTime.utc(2019, 9, 7), locale)
                    .toUpperCase();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            return value.toStringAsFixed(0);
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 1,
      maxX: 6,
      // maxY: 10,
      lineBarsData: [
        LineChartBarData(
            spots: _getEventsSpots(),
            isCurved: true,
            colors: [
              Colors.red[400],
            ],
            preventCurveOverShooting: true,
            // curveSmoothness: 0.20,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: _getGradients(context)
                  .map((color) => color.withOpacity(0.6))
                  .toList(),
              gradientColorStops: [0.5, 1.0],
              gradientFrom: const Offset(0, 0),
              gradientTo: const Offset(0, 1),
            )),
      ],
    );
  }

  List<FlSpot> _getEventsSpots() {
    FLog.info(text: 'Called');
    List<FlSpot> spots = [];
    DateTime today = DateTime.now();
    DateTime firstDay = today.subtract(Duration(days: today.weekday - 1));
    DateTime dayOfWeek = DateTime.utc(today.year, today.month, firstDay.day);
    print(widget.events.length.toString());
    widget.events.forEach((e) {
      print(e.toString());
    });

    for (var i = 1; i <= 6; i++) {
      final numberOfEvents = widget.events.where((e) {
        return e.begin.day == dayOfWeek.day;
      }).length;
      //FLog.info(text: numberOfEvents.toString());
      spots.add(FlSpot(i.toDouble(), numberOfEvents.toDouble()));
      //FLog.info(text: dayOfWeek.toString()  );
      dayOfWeek = dayOfWeek.add(Duration(days: 1));
    }
    return spots;
  }

  List<Color> _getGradients(BuildContext context) {
    List<Color> gradientColors;
    return gradientColors = [
      Colors.red[400],
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white
    ];
  }
}
