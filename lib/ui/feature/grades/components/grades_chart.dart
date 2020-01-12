import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class GradesChart extends StatefulWidget {
  final List<Grade> grades;
  final int objective;

  const GradesChart({
    Key key,
    @required this.grades,
    this.objective,
  }) : super(key: key);

  @override
  _GradesChartState createState() => _GradesChartState();
}

class _GradesChartState extends State<GradesChart> {
  // color gradient for the graph background
  List<Color> gradientColors = [
    Colors.red[400],
    Colors.grey[900],
  ];
  // by defualt we want to show the average
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return _buildChart(context);
  }

  /// Stream builder that takes data from the bloc stream
  Widget _buildChart(BuildContext context) {
    // we take the grades from the state
    final grades = widget.grades;
    // spots for the graph
    List<FlSpot> spots = List<FlSpot>();

    // if we are viewing the average we want to use the average in our points
    if (showAvg) {
      // simple algorithm to calculate avg
      double sum = 0;
      int count = 0;
      double average;

      // good old for, rare these days
      for (int i = 0; i < grades.length; i++) {
        if (grades[i].decimalValue != -1.00) {
          sum += grades[i].decimalValue;
          count++;
          average = sum / count;
          // with num.parse(average.toStringAsFixed(2)) we cut the decimal digits
          spots
              .add(FlSpot(i.toDouble(), num.parse(average.toStringAsFixed(2))));
        }
      }
    } else {
      // if we don't want to see the average we want to see the single grades during that time
      for (int i = 0; i < grades.length; i++) {
        if (grades[i].decimalValue != -1.00) {
          spots.add(FlSpot(i.toDouble(), grades[i].decimalValue));
        }
      }
    }

    if (spots.isEmpty) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LineChart(
                    gradesData(grades, spots, context),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 34,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                AppLocalizations.of(context).translate('avg'),
                style: TextStyle(
                  fontSize: 8,
                  color: showAvg
                      ? Theme.of(context)
                          .primaryTextTheme
                          .headline
                          .color
                          .withOpacity(0.5)
                      : Theme.of(context).primaryTextTheme.headline.color,
                ),
              ),
            ),
          ),
        ],
      );
    }
    // the main widget
  }

  LineChartData gradesData(
    List<Grade> grades,
    List<FlSpot> spots,
    BuildContext context,
  ) {
    double cutOffYValue =
        widget.objective != null ? widget.objective.toDouble() : 6.0;

    return LineChartData(
      // The grid behind the graph
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0.15,
          );
        },
      ),

      // The vertical line for the minimum mark (6.0)
      extraLinesData: ExtraLinesData(
        showVerticalLines: true,
        verticalLines: [
          VerticalLine(
            y: cutOffYValue,
            color: Colors.red[600].withOpacity(0.3),
            strokeWidth: 1.5,
          ),
        ],
      ),

      // All the titles
      titlesData: FlTitlesData(
        show: true,

        // Some dates of the grades
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: const Color(0xff68737d),
              fontWeight: FontWeight.w500,
              fontSize: 12),
          getTitles: (vlue) {
            return '';
          },
          margin: 8,
        ),

        // Left tiles that shows the marks
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.w300,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
            }
            return '';
          },
          reservedSize: 28,
          margin: 10,
        ),
      ),

      // Hide the border
      borderData: FlBorderData(
        show: false,
      ),

      // Set some max-min values
      //maxX: spots.length.toDouble(),
      minY: 0,
      maxY: 10,
      // Data of the graph
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 1.2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          // Color Below the line of the graph
          belowBarData: BarAreaData(
            show: true,
            colors: _getGradients(context)
                .map((color) => color.withOpacity(0.4))
                .toList(),
            gradientColorStops: [0.5, 1.0],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
          // Cut off for showing how much you need for the minmium mark
          aboveBarData: BarAreaData(
            show: true,
            colors: [Colors.grey[500].withOpacity(0.6)],
            cutOffY: cutOffYValue,
            applyCutOffY: true,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradients(BuildContext context) {
    return gradientColors = [
      Colors.red[400],
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white
    ];
  }
}
