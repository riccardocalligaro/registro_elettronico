import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/grades_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/period_tab.dart';

class GradesLoaded extends StatelessWidget {
  final int index;
  final GradesPagesDomainModel gradesPagesDomainModel;

  const GradesLoaded({
    Key key,
    @required this.gradesPagesDomainModel,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: [
        GradesTab(
          grades: gradesPagesDomainModel.grades,
        ),
        ...List.generate(
          gradesPagesDomainModel.periods,
          (index) {
            return PeriodTab(
              periodWithGradesDomainModel:
                  gradesPagesDomainModel.periodsWithGrades[index],
            );
          },
        ),
      ],
      // controller: tabController,
    );
  }
}
