import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/color_utils.dart';

class AbsencesChartBars extends StatefulWidget {
  final Map<int, List<Absence>> absences;

  const AbsencesChartBars({Key key, @required this.absences}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AbsencesChartBarsState();
}

class AbsencesChartBarsState extends State<AbsencesChartBars> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  static const double barWidth = 22;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: 31,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) {
                return TextStyle(color: Colors.black, fontSize: 10);
              },
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Sept';
                  case 1:
                    return 'Feb';
                  case 2:
                    return 'Wed';
                  case 3:
                    return 'Thu';
                  case 4:
                    return 'Fri';
                  case 5:
                    return 'Sat';
                  case 6:
                    return 'Sun';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) {
                return TextStyle(color: Colors.white, fontSize: 10);
              },
              rotateAngle: 45,
              getTitles: (double value) {
                if (value == 0) {
                  return '';
                }
                return '${value.toInt()}0k';
              },
              interval: 5,
              margin: 8,
              reservedSize: 30,
            ),
            rightTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) {
                return TextStyle(color: Colors.white, fontSize: 10);
              },
              rotateAngle: 90,
              getTitles: (double value) {
                if (value == 0) {
                  return '';
                }
                return '${value.toInt()}0k';
              },
              interval: 5,
              margin: 8,
              reservedSize: 30,
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 5 == 0,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(color: Colors.grey, strokeWidth: 1.5);
              }
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.8,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: _getBarChartRodData(9)),
            BarChartGroupData(x: 1, barRods: _getBarChartRodData(10)),
            BarChartGroupData(x: 2, barRods: _getBarChartRodData(11)),
            BarChartGroupData(x: 3, barRods: _getBarChartRodData(12)),
            BarChartGroupData(x: 4, barRods: _getBarChartRodData(1)),
            BarChartGroupData(x: 5, barRods: _getBarChartRodData(2)),
            BarChartGroupData(x: 6, barRods: _getBarChartRodData(3)),
            // BarChartGroupData(x: 0, barRods: _getBarChartRodData(4)),
            // BarChartGroupData(x: 0, barRods: _getBarChartRodData(5)),
            // BarChartGroupData(x: 0, barRods: _getBarChartRodData(6)),
          ],
        ),
      ),
    );
  }

  List<BarChartRodStackItem> _getEventsForMonth(int month) {
    List<Absence> events = widget.absences[month];
    if (events == null) {
      return [
        BarChartRodStackItem(0, 0, Colors.transparent),
      ];
    }
    // Sort by code so a its first
    events.sort((a, b) => a.evtCode.compareTo(b.evtCode));

    List<BarChartRodStackItem> items = [];
    double count = 1;
    events.forEach((event) {
      // print("x" + (count - 1).toString() + " y " + count.toString());
      items.add(BarChartRodStackItem(count - 1.1, count + 0.1,
          ColorUtils.getColorFromCode(event.evtCode)));
      count += 1;
    });

    return items;
  }

  List<BarChartRodData> _getBarChartRodData(int month) {
    final events = widget.absences[month];

    if (events == null) {
      final data = BarChartRodData(
        y: 0,
        width: barWidth,
        //isRound: false,
        rodStackItems: [BarChartRodStackItem(0, 0, Colors.transparent)],
      );
      return [
        data,
      ];
    } else {
      final events = _getEventsForMonth(month);

      return [
        BarChartRodData(
          y: events.length.toDouble(),
          width: barWidth,
          //isRound: false,
          rodStackItems: events,
        )
      ];
    }
  }
}
