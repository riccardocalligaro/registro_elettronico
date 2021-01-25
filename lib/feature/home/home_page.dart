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
import 'package:registro_elettronico/utils/update_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _updateHomeData(context),
        child: ListView(
          padding: EdgeInsets.zero,
          physics: ClampingScrollPhysics(),
          children: [
            HomeHeader(),
            // GRADES
            HomeGrades(),
            // LESSONS
            HomeLessonsHeader(),
            SizedBox(
              height: 140,
              child: HomeLessons(),
            ),
            HomeAgendaHeader(),
            HomeEvents(),
          ],
        ),
      ),
    );
  }

  Future<void> _updateHomeData(BuildContext context) async {
    final SRUpdateManager srUpdateManager = sl();
    return srUpdateManager.updateHomeData(context);
  }
}
