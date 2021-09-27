import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart';

class EmptyGradesPlaceholder extends StatelessWidget {
  const EmptyGradesPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPlaceHolder(
      icon: Icons.timeline,
      showUpdate: true,
      onTap: () async {
        final GradesRepository gradesRepository = sl();
        await gradesRepository.updateGrades(ifNeeded: false);
      },
      text: AppLocalizations.of(context)!.translate('no_grades'),
    );
  }
}
