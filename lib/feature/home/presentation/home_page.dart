import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/app_drawer.dart';
import 'package:registro_elettronico/core/presentation/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/feature/agenda/presentation/updater/agenda_updater_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/updater/grades_updater_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/sections/last_grades_section.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_entity.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:registro_elettronico/utils/update_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sections/next_events_section.dart';

/// [Dashboard] where the user first lands
///   - [Quick shortcuts] for changinc section
///   - [Last grades]
///   - [Last lessons]
///   - [Next eventd]
class HomePage extends StatefulWidget {
  final bool updateData;
  final bool fromSignIn;

  const HomePage({
    Key key,
    this.updateData = false,
    this.fromSignIn = false,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _borderRadiusCard = 8.0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _lastUpdate;
  RefreshController _refreshController = RefreshController();

  List<bool> _refreshed = [false, false, false];

  Profile profile;

  @override
  void initState() {
    super.initState();
    getPreferences();

    if (widget.fromSignIn) {
      _refreshHome();
      UpdateUtils.updateAllData(fromLogin: true);
    } else {
      BlocProvider.of<dash.LessonsDashboardBloc>(context)
          .add(dash.GetLastLessons());

      _refreshHome();
    }

    setState(() {
      profile = RepositoryProvider.of<ProfileRepository>(context).getProfile();
    });
  }

  void getPreferences() async {
    SharedPreferences sharedPreferences = sl();
    setState(() {
      _lastUpdate = sharedPreferences.getInt(PrefsConstants.lastUpdateHome);
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
      floatingActionButton: const SizedBox(height: 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AgendaUpdaterBloc, AgendaUpdaterState>(
            listener: (context, state) {
              if (state is AgendaUpdaterSuccess) {
                _refreshed[2] = true;
                if (_refreshed[0] && _refreshed[1] && _refreshed[2]) {
                  _refreshController.refreshCompleted();

                  _resetRefreshed();

                  setState(() {
                    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
                  });
                }
              }

              if (state is AgendaUpdaterFailure) {
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
          BlocListener<GradesUpdaterBloc, GradesUpdaterState>(
            listener: (context, state) {
              if (state is GradesUpdaterSuccess) {
                _refreshed[0] = true;

                if (_refreshed[0] && _refreshed[1] && _refreshed[2]) {
                  _refreshController.refreshCompleted();

                  _resetRefreshed();

                  setState(() {
                    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
                  });
                }
              } else if (state is GradesUpdaterFailure) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.failure.localizedDescription(context)),
                  ));

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
            color: Theme.of(context).accentColor,
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
                          colors: ColorUtils.getGradientForColor(
                              Theme.of(context).accentColor),
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        ),
                      ),
                    ),
                    _buildTopSection()
                  ],
                ),
                const SizedBox(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(AppLocalizations.of(context)
                          .translate('last_lessons')),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LastLessonsSection(),
                    const SizedBox(
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
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32, left: 5),
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
              const SizedBox(
                height: 16,
              ),
              _buildQuickShortcutsSection()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNameText() {
    if (profile != null) {
      return Text(
        '${DateUtils.localizedTimeMessage(context)}, ${StringUtils.titleCase(profile.firstName ?? '')}.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return Text(
      '${DateUtils.localizedTimeMessage(context)}.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
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
                    colors: ColorUtils.getGradientForColor(
                        Theme.of(context).accentColor),
                    begin: Alignment(-1.0, -2.0),
                    end: Alignment(1.0, 2.0),
                  ),
                ),
              ),
              const SizedBox(
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
      ),
    );
  }

  void _refreshHome() async {
    BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
    BlocProvider.of<AgendaUpdaterBloc>(context)
        .add(UpdateAgenda(onlyLastDays: false));
    BlocProvider.of<GradesUpdaterBloc>(context).add(UpdateGrades());
  }

  void _resetRefreshed() {
    setState(() {
      _refreshed[0] = false;
      _refreshed[1] = false;
      _refreshed[2] = false;
    });
  }
}
