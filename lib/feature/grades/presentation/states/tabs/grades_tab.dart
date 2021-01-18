import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/presentation/widgets/custom_refresher.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/empty_grades.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/grades/grade_card.dart';

class GradesTab extends StatelessWidget {
  final List<GradeDomainModel> grades;

  const GradesTab({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.isEmpty) {
      return EmptyGradesPlaceholder();
    }
    return RefreshIndicator(
      onRefresh: () {
        final GradesRepository gradesRepository = sl();
        return gradesRepository.updateGrades(ifNeeded: false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SRGradeCard(
              grade: grades[index],
            ),
          );
        },
      ),
    );
  }
}
