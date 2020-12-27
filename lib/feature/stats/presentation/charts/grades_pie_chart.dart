import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/stats/presentation/widgets/indicator.dart';

class GradesPieChart extends StatefulWidget {
  final int sufficientiCount;
  final int insufficientiCount;
  final int nearlySufficientiCount;
  final int totalGrades;

  GradesPieChart({
    Key key,
    @required this.sufficientiCount,
    @required this.insufficientiCount,
    @required this.nearlySufficientiCount,
    @required this.totalGrades,
  }) : super(key: key);

  @override
  _GradesPieChartState createState() => _GradesPieChartState();
}

class _GradesPieChartState extends State<GradesPieChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    color: Colors.green,
                    text: AppLocalizations.of(context)
                        .translate('sufficient_grades'),
                    isSquare: false,
                    textColor:
                        touchedIndex == 0 ? Colors.white : Colors.grey[300],
                  ),
                  Indicator(
                    color: Colors.yellow[700],
                    text: AppLocalizations.of(context)
                        .translate('nearly_sufficient_grades'),
                    isSquare: false,
                    textColor:
                        touchedIndex == 0 ? Colors.white : Colors.grey[300],
                  ),
                  Indicator(
                    color: Colors.red,
                    text: AppLocalizations.of(context)
                        .translate('insufficient_grades'),
                    isSquare: false,
                    textColor:
                        touchedIndex == 0 ? Colors.white : Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      //startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 2.5,
                      centerSpaceRadius: 30,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double insuffPercentage =
        ((widget.insufficientiCount / widget.totalGrades) * 100);

    double nearlySuffPercentage =
        ((widget.nearlySufficientiCount / widget.totalGrades) * 100);

    double suffPercentage =
        ((widget.sufficientiCount / widget.totalGrades) * 100);

    return List.generate(
      3,
      (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 14 : 12;
        final double radius = isTouched ? 70 : 65;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.red,
              title:
                  '${insuffPercentage > 0 ? '${insuffPercentage.toStringAsFixed(0)}%' : ''}',
              value: widget.insufficientiCount.toDouble(),
              radius: radius,
              titleStyle:
                  TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.green,
              title:
                  '${suffPercentage > 0 ? '${suffPercentage.toStringAsFixed(0)}%' : ''}',
              value: widget.sufficientiCount.toDouble(),
              radius: radius,
              titleStyle:
                  TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
            );
          case 2:
            return PieChartSectionData(
              color: Colors.yellow[700],
              title:
                  '${nearlySuffPercentage > 0 ? '${nearlySuffPercentage.toStringAsFixed(0)}%' : ''}',
              value: widget.nearlySufficientiCount.toDouble(),
              radius: radius,
              titleStyle:
                  TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
            );

          default:
            return null;
        }
      },
    );
  }
}
