import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/home/sections/events/home_events.dart';
import 'package:registro_elettronico/feature/home/sections/grades/home_grades.dart';
import 'package:registro_elettronico/feature/home/sections/header/home_header.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/home_lessons.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

final GlobalKey<RefreshIndicatorState> homeRefresherKey = GlobalKey();

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: homeRefresherKey,
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
