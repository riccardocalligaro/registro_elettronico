import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/home/sections/events/home_events.dart';
import 'package:registro_elettronico/feature/home/sections/grades/home_grades.dart';
import 'package:registro_elettronico/feature/home/sections/header/home_header.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/home_lessons.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

final GlobalKey<RefreshIndicatorState> homeRefresherKey = GlobalKey();

class HomePage extends StatefulWidget {
  final bool fromLogin;

  const HomePage({
    Key? key,
    this.fromLogin = false,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (widget.fromLogin) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate('updating_home_data')!,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: null,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
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
      ),
    );
  }

  Future<void> _updateHomeData(BuildContext context) async {
    final SRUpdateManager srUpdateManager = sl();
    return srUpdateManager.updateHomeData(context);
  }
}
