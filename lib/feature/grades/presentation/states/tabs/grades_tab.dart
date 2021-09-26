import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/empty_grades.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/grades/grade_card.dart';

class GradesTab extends StatelessWidget {
  final List<GradeDomainModel> grades;

  const GradesTab({
    Key? key,
    required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height -
            170 -
            MediaQuery.of(context).viewPadding.top,
        width: MediaQuery.of(context).size.width,
        child: EmptyGradesPlaceholder(),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        final GradesRepository gradesRepository = sl();
        return gradesRepository.updateGrades(ifNeeded: false);
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          if (index == 0 && !grades[0].hasSeenIt!) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('not_seen_grades')!
                          .toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SRGradeCard(
                    grade: grades[index],
                  ),
                ],
              ),
            );
          }

          if (!grades[0].hasSeenIt! &&
              index >= 1 &&
              !grades[index - 1].hasSeenIt! &&
              grades[index].hasSeenIt!) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('seen_grades')!
                          .toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SRGradeCard(
                    grade: grades[index],
                  ),
                ],
              ),
            );
          }

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
