import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class PeriodGradeCard extends StatelessWidget {
  final PeriodGradeDomainModel subjectData;

  const PeriodGradeCard({
    Key key,
    @required this.subjectData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 6.0,
                  percent: _getPercentAverage(subjectData.average),
                  backgroundColor: GlobalUtils.isDark(context)
                      ? Colors.white
                      : Colors.grey.withOpacity(0.3),
                  animation: true,
                  animationDuration: 300,
                  center: Text(
                    subjectData.average <= 0
                        ? '-'
                        : subjectData.average.toStringAsFixed(2),
                  ),
                  progressColor: _getColorFromAverage(subjectData.average),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    subjectData.subject.name.length < 20
                        ? subjectData.subject.name
                        : GlobalUtils.reduceSubjectTitle(
                            subjectData.subject.name),
                    maxLines: 1,
                  ),
                  Text(
                    _getGradeNeededMessage(
                      gradeNeededForObjective:
                          subjectData.gradeNeededForObjective,
                      context: context,
                    ),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyText2
                        .copyWith(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGradeNeededMessage({
    @required GradeNeededDomainModel gradeNeededForObjective,
    @required BuildContext context,
  }) {
    if (gradeNeededForObjective.message == GradeNeededMessage.dont_worry) {
      return AppLocalizations.of(context).translate('dont_worry');
    } else if (gradeNeededForObjective.message ==
        GradeNeededMessage.unreachable) {
      return AppLocalizations.of(context).translate('objective_unreacheable');
    } else if (gradeNeededForObjective.message ==
        GradeNeededMessage.not_less_then) {
      return "${AppLocalizations.of(context).translate('dont_get_less_than')} ${gradeNeededForObjective.value}";
    } else if (gradeNeededForObjective.message ==
        GradeNeededMessage.get_at_lest) {
      return "${AppLocalizations.of(context).translate('get_at_least')} ${gradeNeededForObjective.value}";
    }

    return AppLocalizations.of(context).translate('calculation_error');
  }

  double _getPercentAverage(double average) {
    if (average == -1) return 1.0;
    return average / 10;
  }

  Color _getColorFromAverage(double value) {
    if (value == -1.00) {
      return Colors.white;
    } else if (value == 0.00) {
      return Colors.blue;
    } else if (value >= 6) {
      return Colors.green;
    } else if (value >= 5.5 && value < 6) {
      return Colors.yellow[700];
    } else {
      return Colors.red;
    }
  }
}
