import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/period/period_grade_card.dart';

class PeriodGradesList extends StatelessWidget {
  final PeriodWithGradesDomainModel periodWithGradesDomainModel;

  const PeriodGradesList({
    Key key,
    @required this.periodWithGradesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: periodWithGradesDomainModel.gradesForList.length,
      itemBuilder: (context, index) {
        final grade = periodWithGradesDomainModel.gradesForList[index];

        return PeriodGradeCard(
          subjectData: grade,
          periodPos: periodWithGradesDomainModel.period.periodIndex,
        );
      },
    );
  }
}
