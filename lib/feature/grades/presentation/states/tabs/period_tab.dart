import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/empty_grades.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_grades_list.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_stats_card.dart';

class PeriodTab extends StatelessWidget {
  final PeriodWithGradesDomainModel periodWithGradesDomainModel;

  const PeriodTab({
    Key key,
    @required this.periodWithGradesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (periodWithGradesDomainModel.grades.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height -
            152 -
            MediaQuery.of(context).viewPadding.top,
        width: MediaQuery.of(context).size.width,
        child: EmptyGradesPlaceholder(),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        if (!periodWithGradesDomainModel.average.isNaN)
          PeriodStatsCard(
            periodWithGradesDomainModel: periodWithGradesDomainModel,
          ),
        const SizedBox(
          height: 8,
        ),
        PeriodGradesList(
          periodWithGradesDomainModel: periodWithGradesDomainModel,
        ),
      ],
    );
  }
}
