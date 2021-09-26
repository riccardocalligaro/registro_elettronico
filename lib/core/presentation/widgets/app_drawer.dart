import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/feature/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:registro_elettronico/feature/debug/presentation/debug_page.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/settings/widgets/account/account_settings.dart';
import 'package:registro_elettronico/feature/web/presentation/spaggiari_web_view.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:share/share.dart';

class AppDrawer extends StatefulWidget {
  final int position;

  AppDrawer({
    Key key,
    this.position,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with AutomaticKeepAliveClientMixin {
  List<bool> selectedList = List<bool>.filled(14, false);
  bool _showUserDetails = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    selectedList[widget.position] = true;
    return Drawer(
      child: Column(
        children: <Widget>[
          _createHeader(context),
          Expanded(
            child:
                _showUserDetails ? _createUserDetailsList() : _createMenuList(),
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return FutureBuilder(
      // todo: need to fix null
      future: _getUsername(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var ident = " ";
        var firstName = " ";
        var lastName = " ";

        if (snapshot.data != null) {
          ident = snapshot.data.ident;
          firstName = snapshot.data.firstName;
          lastName = snapshot.data.lastName;
        }

        return UserAccountsDrawerHeader(
          margin: EdgeInsets.zero,
          accountEmail: Text(ident,
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyText2
                  .copyWith(color: Colors.white)),
          accountName: Text('$firstName $lastName'),
          currentAccountPicture: CircleAvatar(
            child: Text(firstName[0] + lastName[0]),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onDetailsPressed: () {
            setState(() {
              _showUserDetails = !_showUserDetails;
            });
          },
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [0.4, 1],
              colors:
                  ColorUtils.getGradientForColor(Theme.of(context).accentColor),
              begin: Alignment(-1.0, -2.0),
              end: Alignment(1.0, 2.0),
            ),
          ),
        );
      },
    );
  }

  Widget _createUserDetailsList() {
    return Container(
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createDrawerItem(
              icon: Icons.settings_backup_restore,
              text: "Reset",
              onTap: () {
                showDialog(
                    context: context, builder: (context) => ResetDialog());
              },
              pos: 1,
              isAccount: true,
            ),
            _createDrawerItem(
              icon: Icons.exit_to_app,
              text: AppLocalizations.of(context).translate('logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context).translate('reset_db_alert'),
                    ),
                    content: Text(AppLocalizations.of(context)
                        .translate('logout_message')),
                    actions: <Widget>[
                      TextButton(
                        child:
                            Text(AppLocalizations.of(context).translate('no')),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child:
                            Text(AppLocalizations.of(context).translate('yes')),
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(SignOut());

                          AppNavigator.instance.navToLogin(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              pos: 2,
              isAccount: true,
            )
          ],
        ),
      ),
    );
  }

  Widget _createMenuList() {
    final trans = AppLocalizations.of(context);
    return Container(
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            !kReleaseMode
                ? _createDrawerItem(
                    icon: Icons.bug_report,
                    text: 'Debug',
                    pos: 13,
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DebugPage()));
                    },
                  )
                : Container(),
            _createDrawerItem(
              icon: Icons.home,
              text: trans.translate("home"),
              pos: DrawerConstants.HOME,
              onTap: () {
                //Navigator.pop(context);
                //Navigator.pushReplacementNamed(context, Routes.HOME);
                AppNavigator.instance.navToHome(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.library_books,
              text: trans.translate("lessons"),
              pos: DrawerConstants.LESSONS,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToLessons(context);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, Routes.LESSONS, (Route<dynamic> route) => false);
              },
            ),
            _createDrawerItem(
              icon: Icons.timeline,
              text: trans.translate("grades"),
              pos: DrawerConstants.GRADES,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToGrades(context);

                // Navigator.pushNamedAndRemoveUntil(
                //     context, Routes.GRADES, ((Route<dynamic> route) => false));
              },
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: trans.translate("agenda"),
              pos: DrawerConstants.AGENDA,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToAgenda(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.assessment,
              text: trans.translate("absences"),
              pos: DrawerConstants.ABSENCES,
              onTap: () {
                Navigator.pop(context);

                AppNavigator.instance.navToAbsences(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.folder,
              text: trans.translate("school_material"),
              pos: DrawerConstants.SCHOOL_MATERIAL,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToSchoolMaterial(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.info,
              text: trans.translate("notes"),
              pos: DrawerConstants.NOTES,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToNotes(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.assignment,
              text: trans.translate("notice_board"),
              pos: DrawerConstants.NOTICE_BOARD,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToNoticeboard(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.access_time,
              text: AppLocalizations.of(context).translate('timetable'),
              pos: DrawerConstants.TIMETABLE,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToTimetable(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.import_contacts,
              text: AppLocalizations.of(context).translate('scrutini'),
              pos: DrawerConstants.SCRUTINI,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToScrutini(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.pie_chart,
              text: AppLocalizations.of(context).translate('statistics'),
              pos: DrawerConstants.STATS,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToStats(context);
              },
            ),
            Divider(),
            _createDrawerItem(
              icon: Icons.web,
              text: trans.translate('web'),
              pos: 12,
              onTap: () {
                final url =
                    'https://web.spaggiari.eu/home/app/default/login.php?index.php';
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SpaggiariWebView(
                      appBarTitle: trans.translate('web'),
                      url: url,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            _createDrawerItem(
              icon: Icons.settings,
              text: trans.translate("settings"),
              pos: DrawerConstants.SETTINGS,
              onTap: () {
                Navigator.pop(context);
                AppNavigator.instance.navToSettings(context);
              },
            ),
            _createDrawerItem(
              icon: Icons.share,
              text: trans.translate("share"),
              pos: DrawerConstants.SHARE,
              onTap: () {
                Share.share(
                  trans.translate('share_message').replaceAll('{download_url}',
                      'https://play.google.com/store/apps/details?id=com.riccardocalligaro.registro_elettronico'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    IconData icon,
    String text,
    GestureTapCallback onTap,
    int pos,
    bool isAccount,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: selectedList[pos] == true && (isAccount ?? false) == false
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryIconTheme.color,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text, style: TextStyle(color: _getColor(isAccount))),
          )
        ],
      ),
      onTap: onTap,
      selected: selectedList[pos],
    );
  }

  Future<ProfileDomainModel> _getUsername() async {
    final profile =
        await RepositoryProvider.of<AuthenticationRepository>(context)
            .getProfile();
    return await profile;
  }

  Color _getColor(bool isAccount) {
    if (isAccount ?? false) {
      return Theme.of(context).textTheme.bodyText2.color;
    } else {
      return null;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
