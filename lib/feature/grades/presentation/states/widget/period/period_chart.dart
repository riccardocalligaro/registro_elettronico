import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';

class GradesChart extends StatefulWidget {
  final List<GradeDomainModel> grades;
  final List<FlSpot> averageSpots;
  final List<FlSpot> normalSpots;
  final int overallObjective;

  const GradesChart({
    Key key,
    @required this.averageSpots,
    @required this.normalSpots,
    @required this.overallObjective,
    @required this.grades,
  }) : super(key: key);

  @override
  _GradesChartState createState() => _GradesChartState();
}

class _GradesChartState extends State<GradesChart> {
  // by defualt we want to show the average
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    if (widget.normalSpots.isEmpty) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: showAvg
                      ? GradesLineChart(
                          spots: widget.normalSpots,
                          grades: widget.grades,
                          cutOffYValue: widget.overallObjective != null
                              ? widget.overallObjective.toDouble()
                              : 6.0,
                        )
                      : GradesLineChart(
                          spots: widget.averageSpots,
                          grades: widget.grades,
                          cutOffYValue: widget.overallObjective != null
                              ? widget.overallObjective.toDouble()
                              : 6.0,
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
                          .headline5
                          .color
                          .withOpacity(0.5)
                      : Theme.of(context).primaryTextTheme.headline5.color,
                ),
              ),
            ),
          ),
        ],
      );
    }
    // the main widget
  }
}

class GradesLineChart extends StatelessWidget {
  final List<GradeDomainModel> grades;
  final List<FlSpot> spots;
  final double cutOffYValue;

  const GradesLineChart({
    Key key,
    @required this.grades,
    @required this.spots,
    @required this.cutOffYValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xff37434d),
              strokeWidth: 0.15,
            );
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: cutOffYValue,
              color: Theme.of(context).accentColor.withOpacity(0.3),
              strokeWidth: 1.5,
            ),
          ],
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) {
              return TextStyle(
                color: const Color(0xff68737d),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              );
            },
            getTitles: (vlue) {
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) {
              return TextStyle(
                color: const Color(0xff67727d),
                fontWeight: FontWeight.w300,
                fontSize: 10,
              );
            },
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
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 1.2,
            colors: [
              Theme.of(context).accentColor,
            ],
            isStrokeCapRound: true,
            dotData: FlDotData(
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
      ),
    );
  }

  List<Color> _getGradients(BuildContext context) {
    return [
      Theme.of(context).accentColor,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white
    ];
  }
}
