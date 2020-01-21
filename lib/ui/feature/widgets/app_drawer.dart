import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/component/routes.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';
import 'package:registro_elettronico/ui/feature/next_tests/next_tests_page.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
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
  List<bool> selectedList = new List<bool>.filled(14, false);
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
                  .body1
                  .copyWith(color: Colors.white)),
          accountName: Text("$firstName $lastName"),
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
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
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
                icon: Icons.exit_to_app,
                text: "Logout",
                onTap: () {
                  BlocProvider.of<IntroBloc>(context).add(Reset());
                  BlocProvider.of<AuthBloc>(context).add(SignOut());
                  AppNavigator.instance.navToLogin(context);
                },
                pos: 0,
                isAccount: true)
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
            _createDrawerItem(
              icon: Icons.home,
              text: trans.translate("home"),
              pos: DrawerConstants.HOME,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.LESSONS,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.library_books,
              text: trans.translate("lessons"),
              pos: DrawerConstants.LESSONS,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.LESSONS,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.timeline,
              text: trans.translate("grades"),
              pos: DrawerConstants.GRADES,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.GRADES,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: trans.translate("agenda"),
              pos: DrawerConstants.AGENDA,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.AGENDA,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
                icon: Icons.folder,
                text: trans.translate("school_material"),
                pos: DrawerConstants.SCHOOL_MATERIAL,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.SCHOOL_MATERIAL, (Route<dynamic> route) {
                    return route.isCurrent;
                  });
                }),
            _createDrawerItem(
              icon: Icons.assessment,
              text: trans.translate("absences"),
              pos: DrawerConstants.ABSENCES,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.ABSENCES,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.info,
              text: trans.translate("notes"),
              pos: DrawerConstants.NOTES,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.NOTES,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.assignment,
              text: trans.translate("notice_board"),
              pos: DrawerConstants.NOTICE_BOARD,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.NOTICEBOARD,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.access_time,
              text: AppLocalizations.of(context).translate('timetable'),
              pos: DrawerConstants.TIMETABLE,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.TIMETABLE,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.import_contacts,
              text: AppLocalizations.of(context).translate('scrutini'),
              pos: DrawerConstants.SCRUTINI,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.SCRUTINI,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            // _createDrawerItem(
            //   icon: Icons.archive,
            //   text: trans.translate('last_year'),
            //   pos: DrawerConstants.ANNO_PRECEDENTE,
            //   onTap: () {
            //     AppNavigator.instance.navToWebView(
            //       context,
            //       'https://web18.spaggiari.eu/home/app/default/menu_webinfoschool_studenti.php?custcode=',
            //     );
            //   },
            // ),
            // _createDrawerItem(
            //   icon: Icons.web,
            //   text: trans.translate('web'),
            //   pos: DrawerConstants.WEB,
            //   onTap: () {
            //     AppNavigator.instance.navToScrutini(context);
            //   },
            // ),
            Divider(),
            _createDrawerItem(
              icon: Icons.settings,
              text: trans.translate("settings"),
              pos: DrawerConstants.SETTINGS,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.SETTINGS,
                    (Route<dynamic> route) {
                  return route.isCurrent;
                });
              },
            ),
            _createDrawerItem(
              icon: Icons.share,
              text: trans.translate("share"),
              pos: DrawerConstants.SHARE,
              onTap: () {
                Share.share(AppLocalizations.of(context)
                    .translate('share_message')
                    .replaceAll('{download_url}',
                        'https://github.com/Zuccante-Web-App'));
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
                ? Colors.red
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

  Future<Profile> _getUsername() async {
    final profile =
        await RepositoryProvider.of<ProfileRepository>(context).getDbProfile();
    return await profile;
  }

  Color _getColor(bool isAccount) {
    if (isAccount ?? false) {
      return Theme.of(context).textTheme.body1.color;
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
