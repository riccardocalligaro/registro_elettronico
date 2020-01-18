import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/lessons/bloc.dart'
    as dash;
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/sections/last_grades_section.dart';
import 'package:registro_elettronico/ui/feature/home/sections/last_lessons_section.dart';
import 'package:registro_elettronico/ui/feature/home/sections/next_events_section.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/double_back_to_close_app.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [Dashboard] where the user first lands
///   - [Quick shortcuts] for changinc section
///   - [Last grades]
///   - [Last lessons]
///   - [Next eventd]
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _borderRadiusCard = 8.0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _lastUpdate;
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getPreferences();
    BlocProvider.of<dash.LessonsDashboardBloc>(context)
        .add(dash.GetLastLessons());
    BlocProvider.of<GradesBloc>(context).add(GetGrades(limit: 3));
    BlocProvider.of<AgendaDashboardBloc>(context).add(GetEvents());
  }

  getPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _lastUpdate = sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AgendaBloc, AgendaState>(
          listener: (context, state) {
            if (state is AgendaUpdateLoadSuccess) {
              BlocProvider.of<AgendaDashboardBloc>(context).add(GetEvents());
            }
          },
        ),
        BlocListener<LessonsBloc, LessonsState>(
          listener: (context, state) {
            if (state is LessonsUpdateLoadSuccess) {
              BlocProvider.of<LessonsDashboardBloc>(context)
                  .add(dash.GetLastLessons());
              setState(() {
                _lastUpdate = DateTime.now().millisecondsSinceEpoch;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        key: _drawerKey,
        drawer: AppDrawer(
          position: DrawerConstants.HOME,
        ),
        bottomNavigationBar: LastUpdateBottomSheet(
          millisecondsSinceEpoch: _lastUpdate,
        ),
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppLocalizations.of(context).translate('leave_snackbar'),
            ),
          ),
          child: SmartRefresher(
            controller: _refreshController,
            header: MaterialClassicHeader(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              color: Colors.red,
            ),
            onRefresh: _refreshHome,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.4, 1],
                            colors: <Color>[Colors.red[400], Colors.red[900]],
                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 2.0),
                          ),
                        ),
                      ),
                      _buildWelcomeSection(),
                      Positioned(
                        top: 150,
                        left: 16,
                        right: 16,
                        child: _buildQuickShortcutsSection(),
                      ),
                      Container(
                        height: 280,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(AppLocalizations.of(context)
                            .translate('last_grades')),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: LastGradesSection(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(AppLocalizations.of(context)
                            .translate('last_lessons')),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      LastLessonsSection(),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(AppLocalizations.of(context)
                            .translate('next_events')),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: NextEventsSection(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return ;
  }

  Widget _buildWelcomeSection() {
    return Positioned(
      top: 40,
      left: -16,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  _drawerKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                padding: const EdgeInsets.all(15.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: FutureBuilder(
                  future: RepositoryProvider.of<ProfileRepository>(context)
                      .getDbProfile(),
                  initialData: GlobalUtils.getMockProfile(),
                  builder: (context, snapshot) {
                    final Profile profile = snapshot.data;
                    return Text(
                      '${AppLocalizations.of(context).translate('welcome_message')}, ${StringUtils.titleCase(profile.firstName)}.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  DateUtils.convertDateLocale(DateTime.now(),
                      AppLocalizations.of(context).locale.toString()),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickShortcutsSection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusCard),
      ),
      elevation: 2,
      child: Container(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildSectionIcon(
                AppLocalizations.of(context).translate('agenda'), Icons.event,
                () {
              AppNavigator.instance.navToAgenda(context);
            }),
            _buildSectionIcon(AppLocalizations.of(context).translate('grades'),
                Icons.timeline, () {
              AppNavigator.instance.navToGrades(context);
            }),
            _buildSectionIcon(
                AppLocalizations.of(context).translate('timetable'),
                Icons.access_time, () {
              AppNavigator.instance.navToTimetable(context);
            }),
            _buildSectionIcon(AppLocalizations.of(context).translate('notices'),
                Icons.assignment, () {
              AppNavigator.instance.navToNoticeboard(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionIcon(
      String name, IconData icon, GestureTapCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 60,
                height: 60,
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    stops: [0.4, 1],
                    colors: <Color>[Colors.red[400], Colors.red[900]],
                    begin: Alignment(-1.0, -2.0),
                    end: Alignment(1.0, 2.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  void _refreshHome() async {
    BlocProvider.of<LessonsBloc>(context).add(UpdateTodayLessons());
    BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
    BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
    BlocProvider.of<GradesBloc>(context).add(GetGrades(limit: 3));
    await Future.delayed(Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
  }
}
