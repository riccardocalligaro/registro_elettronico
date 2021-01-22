import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/home/sections/events/home_events.dart';
import 'package:registro_elettronico/feature/home/sections/grades/home_grades.dart';
import 'package:registro_elettronico/feature/home/sections/header/home_header.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/home_lessons.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _updateHomeData(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeHeader(),
            HomeGrades(),
            HomeLessons(),
            HomeEvents(),
          ],
        ),
      ),
    );
  }

  Future<void> _updateHomeData(BuildContext context) async {
    try {
      final GradesRepository gradesRepository = sl();
      final AgendaRepository agendaRepository = sl();
      final LessonsRepository lessonsRepository = sl();

      await gradesRepository.updateGrades(ifNeeded: false);
      await agendaRepository.updateAllAgenda(ifNeeded: false);
      await lessonsRepository.updateTodaysLessons(ifNeeded: false);
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            handleError(e).localizedDescription(context) ??
                AppLocalizations.of(context).translate('update_error_snackbar'),
          ),
        ),
      );
    }
  }
}
