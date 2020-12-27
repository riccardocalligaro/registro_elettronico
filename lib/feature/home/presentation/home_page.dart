import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/grades_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/sections/last_grades_section.dart';
import 'package:registro_elettronico/feature/lessons/presentation/bloc/lessons_bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ui/global/localizations/app_localizations.dart';
import 'blocs/agenda/agenda_dashboard_bloc.dart';
import 'blocs/grades/grades_dashboard_bloc.dart';
import 'blocs/lessons/lessons_dashboard_bloc.dart' as dash;
import 'blocs/lessons/lessons_dashboard_bloc.dart';
import 'sections/last_lessons_section.dart';
import 'sections/next_events_section.dart';

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

  List<bool> _refreshed = [false, false, false];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    BlocProvider.of<dash.LessonsDashboardBloc>(context)
        .add(dash.GetLastLessons());
    BlocProvider.of<GradesDashboardBloc>(context).add(GetDashboardGrades());
    BlocProvider.of<AgendaDashboardBloc>(context).add(GetEvents());
  }

  getPreferences() async {
    SharedPreferences sharedPreferences = sl();
    setState(() {
      _lastUpdate = sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        drawer: AppDrawer(
          position: DrawerConstants.HOME,
        ),
        bottomNavigationBar: LastUpdateBottomSheet(
          millisecondsSinceEpoch: _lastUpdate,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AgendaBloc, AgendaState>(
              listener: (context, state) {
                if (state is AgendaUpdateLoadSuccess) {
                  BlocProvider.of<AgendaDashboardBloc>(context)
                      .add(GetEvents());

                  _refreshed[2] = true;
                  if (_refreshed[0] && _refreshed[1] && _refreshed[2]) {
                    _refreshController.refreshCompleted();

                    _resetRefreshed();

                    setState(() {
                      _lastUpdate = DateTime.now().millisecondsSinceEpoch;
                    });
                  }
                }

                if (state is AgendaLoadErrorNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context),
                    );

                  _refreshController.refreshFailed();
                } else if (state is AgendaLoadError) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        AppLocalizations.of(context)
                            .translate('update_error_snackbar'),
                      ),
                    ));
                  _refreshController.refreshFailed();
                }
              },
            ),
            BlocListener<GradesBloc, GradesState>(
              listener: (context, state) {
                if (state is GradesUpdateLoaded) {
                  BlocProvider.of<GradesDashboardBloc>(context)
                      .add(GetDashboardGrades());

                  _refreshed[0] = true;

                  if (_refreshed[0] && _refreshed[1] && _refreshed[2]) {
                    _refreshController.refreshCompleted();

                    _resetRefreshed();

                    setState(() {
                      _lastUpdate = DateTime.now().millisecondsSinceEpoch;
                    });
                  }
                } else if (state is GradesUpdateError) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        AppLocalizations.of(context)
                            .translate('update_error_snackbar'),
                      ),
                    ));

                  _refreshController.refreshFailed();
                } else if (state is GradesErrorNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context),
                    );
                  _refreshController.refreshFailed();
                }
              },
            ),
            BlocListener<LessonsBloc, LessonsState>(
              listener: (context, state) {
                if (state is LessonsUpdateLoadSuccess) {
                  BlocProvider.of<LessonsDashboardBloc>(context)
                      .add(dash.GetLastLessons());

                  _refreshed[1] = true;

                  if (_refreshed[0] && _refreshed[1] && _refreshed[2]) {
                    _refreshController.refreshCompleted();
                    _resetRefreshed();

                    setState(() {
                      _lastUpdate = DateTime.now().millisecondsSinceEpoch;
                    });
                  }
                } else if (state is LessonsLoadErrorNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context),
                    );
                  _refreshController.refreshFailed();
                } else if (state is LessonsLoadError) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        AppLocalizations.of(context)
                            .translate('update_error_snackbar'),
                      ),
                    ));
                  _refreshController.refreshFailed();
                }
              },
            ),
          ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      _buildTopSection()
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(AppLocalizations.of(context)
                            .translate('last_grades')),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: LastGradesSection(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(AppLocalizations.of(context)
                            .translate('last_lessons')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LastLessonsSection(),
                      SizedBox(
                        height: 10,
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
        ));
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 5),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNameText(),
              Text(
                DateUtils.convertDateLocale(DateTime.now(),
                    AppLocalizations.of(context).locale.toString()),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _buildQuickShortcutsSection()
            ],
          ),
        )
      ],
    );
  }

  // Widget _buildWelcomeSection() {
  //   return Positioned(
  //     top: 40,
  //     left: -16,
  //     right: 0,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             RawMaterialButton(
  //               onPressed: () {
  //                 _drawerKey.currentState.openDrawer();
  //               },
  //               child: Icon(
  //                 Icons.menu,
  //                 color: Colors.white,
  //               ),
  //               shape: CircleBorder(),
  //               elevation: 2.0,
  //               padding: const EdgeInsets.all(15.0),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 32.0),
  //               child: FutureBuilder(
  //                 future: RepositoryProvider.of<ProfileRepository>(context)
  //                     .getDbProfile(),
  //                 initialData: GlobalUtils.getMockProfile(),
  //                 builder: (context, snapshot) {
  //                   final Profile profile = snapshot.data;
  //                   if (profile != null) {
  //                     return Text(
  //                       '${AppLocalizations.of(context).translate('welcome_message')}, ${StringUtils.titleCase(profile.firstName ?? '')}.',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     );
  //                   }
  //                   return Text(
  //                     '${AppLocalizations.of(context).translate('welcome_message')}}.',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 32.0),
  //               child: Text(
  //                 DateUtils.convertDateLocale(DateTime.now(),
  //                     AppLocalizations.of(context).locale.toString()),
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNameText() {
    return FutureBuilder(
      future: RepositoryProvider.of<ProfileRepository>(context).getDbProfile(),
      initialData: GlobalUtils.getMockProfile(),
      builder: (context, snapshot) {
        final Profile profile = snapshot.data;
        if (profile != null) {
          return Text(
            '${AppLocalizations.of(context).translate('welcome_message')}, ${StringUtils.titleCase(profile.firstName ?? '')}.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          );
        }
        return Text(
          '${AppLocalizations.of(context).translate('welcome_message')}}.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }

  Widget _buildQuickShortcutsSection() {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusCard),
      ),
      elevation: 2,
      child: Container(
        height: 120,
        // width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: _buildSectionIcon(
                  AppLocalizations.of(context).translate('agenda'), Icons.event,
                  () {
                AppNavigator.instance.navToAgenda(context);
              }),
            ),
            Flexible(
              child: _buildSectionIcon(
                  AppLocalizations.of(context).translate('grades'),
                  Icons.timeline, () {
                AppNavigator.instance.navToGrades(context);
              }),
            ),
            Flexible(
              child: _buildSectionIcon(
                  AppLocalizations.of(context).translate('timetable'),
                  Icons.access_time, () {
                AppNavigator.instance.navToTimetable(context);
              }),
            ),
            Flexible(
              child: _buildSectionIcon(
                  AppLocalizations.of(context).translate('notices'),
                  Icons.assignment, () {
                AppNavigator.instance.navToNoticeboard(context);
              }),
            ),
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
            AutoSizeText(
              name,
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  void _refreshHome() async {
    BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
    BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
    BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
  }

  void _resetRefreshed() {
    _refreshed[0] = false;
    _refreshed[1] = false;
    _refreshed[2] = false;
  }
}
