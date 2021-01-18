import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/empty_grades.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_chart.dart';
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
      return EmptyGradesPlaceholder();
    }

    return RefreshIndicator(
      onRefresh: () {
        final GradesRepository gradesRepository = sl();
        return gradesRepository.updateGrades(ifNeeded: false);
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          PeriodStatsCard(
            periodWithGradesDomainModel: periodWithGradesDomainModel,
          ),
          const SizedBox(
            height: 8,
          ),
          PeriodGradesList(
            periodWithGradesDomainModel: periodWithGradesDomainModel,
          )
        ],
      ),
    );
  }
}
