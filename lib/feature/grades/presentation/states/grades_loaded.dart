import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/grades_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/period_tab.dart';

class GradesLoaded extends StatelessWidget {
  final TabController tabController;
  final GradesPagesDomainModel gradesPagesDomainModel;

  const GradesLoaded({
    Key key,
    @required this.gradesPagesDomainModel,
    @required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedTabBarView(
      children: [
        GradesTab(
          grades: gradesPagesDomainModel.grades,
        ),
        PeriodTab(
          periodWithGradesDomainModel:
              gradesPagesDomainModel.periodsWithGrades[0],
        ),
        PeriodTab(
          periodWithGradesDomainModel:
              gradesPagesDomainModel.periodsWithGrades[1],
        ),
        PeriodTab(
          periodWithGradesDomainModel:
              gradesPagesDomainModel.periodsWithGrades[2],
        ),
      ],
      controller: tabController,
      cacheExtent: 2,
    );
  }
}
