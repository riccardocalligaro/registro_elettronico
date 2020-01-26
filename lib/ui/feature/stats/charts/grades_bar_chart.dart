import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradesBarChart extends StatefulWidget {
  final List<Grade> grades;

  const GradesBarChart({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GradesBarChartState();
}

class GradesBarChartState extends State<GradesBarChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = Duration(milliseconds: 250);
  int currentIndex = 0;
  int touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('grades'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('bar_chart_message'),
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(AppLocalizations.of(context)
                      .translate('y_axis_chart')
                      .toLowerCase()),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? timelineData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        currentIndex = 0;
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800],
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toStringAsFixed(0),
                TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white),
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          margin: 14,
          getTitles: (double value) {
            if (value == 0) return '<3';
            return (value + 3).toStringAsFixed(0);
          },
        ),
        leftTitles: SideTitles(
            margin: 16.0,
            showTitles: true,
            textStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            getTitles: (double value) {
              return value.toStringAsFixed(0);
            }),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(8, (i) {
        if (i == 0) {
          return makeGroupData(
            i,
            widget.grades
                .where((g) => g.decimalValue >= 1 && g.decimalValue <= 3)
                .length
                .toDouble(),
            isTouched: i == touchedIndex,
          );
        } else {
          return makeGroupData(
            i,
            widget.grades
                .where((g) => g.decimalValue >= i + 3 && g.decimalValue < i + 4)
                .length
                .toDouble(),
            isTouched: i == touchedIndex,
          );
        }
      });

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: GlobalUtils.getColorFromAverage(x + 3.toDouble()),
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        ),
      ],
    );
  }

  BarChartData timelineData() {
    return BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.white,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.y.toStringAsFixed(0),
                  TextStyle(color: Colors.black),
                );
              }),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            margin: 14,
            getTitles: (double value) {
              if (value == 0) return '<3';
              return (value + 3).toStringAsFixed(0);
            },
          ),
          leftTitles: SideTitles(
            margin: 8.0,
            showTitles: true,
            textStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            getTitles: (double value) {
              return value.toStringAsFixed(0);
            },
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: List.generate(8, (i) {
          return makeGroupData(
              i,
              widget.grades
                  .getRange(0, currentIndex)
                  .where(
                      (g) => g.decimalValue >= i + 3 && g.decimalValue < i + 4)
                  .length
                  .toDouble(),
              isTouched: i == touchedIndex);
        }));
  }

  Future<dynamic> refreshState() async {
    setState(() {});

    if (currentIndex == 0) {
      await Future<dynamic>.delayed(animDuration + Duration(milliseconds: 300));
    } else {
      await Future<dynamic>.delayed(animDuration + Duration(milliseconds: 10));
    }
    if (isPlaying) {
      //showData(currentIndex);

      if (currentIndex < widget.grades.length) {
        currentIndex++;
        refreshState();
      } else {
        setState(() {
          isPlaying = !isPlaying;
        });
      }
    }
  }
}
