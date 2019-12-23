import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

class AppDrawer extends StatefulWidget {
  ProfileDao profileDao;
  final int position;

  AppDrawer({
    Key key,
    this.profileDao,
    this.position,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<bool> selectedList = new List<bool>.filled(12, false);

  @override
  Widget build(BuildContext context) {
    AppLocalizations trans = AppLocalizations.of(context);
    selectedList[widget.position] = true;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: trans.translate("home"),
            pos: DrawerConstants.HOME,
            onTap: () {
              AppNavigator.instance.navToHome(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.library_books,
            text: trans.translate("lessons"),
            pos: DrawerConstants.LESSONS,
            onTap: () {
              AppNavigator.instance.navToLessons(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.timeline,
            text: trans.translate("grades"),
            pos: DrawerConstants.GRADES,
            onTap: () {
              AppNavigator.instance.navToGrades(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: trans.translate("agenda"),
            pos: DrawerConstants.AGENDA,
            onTap: () {
              AppNavigator.instance.navToAgenda(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.folder,
            text: trans.translate("school_material"),
            pos: DrawerConstants.SCHOOL_MATERIAL,
          ),
          _createDrawerItem(
            icon: Icons.assessment,
            text: trans.translate("absences"),
            pos: DrawerConstants.ABSENCES,
            onTap: () {
              AppNavigator.instance.navToAbsences(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.warning,
            text: trans.translate("notes"),
            pos: DrawerConstants.NOTES,
          ),
          _createDrawerItem(
            icon: Icons.assignment,
            text: trans.translate("notice_board"),
            pos: DrawerConstants.NOTICE_BOARD,
            onTap: () {
              AppNavigator.instance.navToNoticeboard(context);
            },
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.settings,
            text: trans.translate("settings"),
            pos: 8,
          ),
          _createDrawerItem(
            icon: Icons.share,
            text: trans.translate("share"),
            pos: 9,
          ),
          _createDrawerItem(
            icon: Icons.send,
            text: trans.translate("contact_us"),
            pos: 10,
          ),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: "Logout",
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(SignOut());
                AppNavigator.instance.navToLogin(context);
              },
              pos: 11)
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return FutureBuilder(
      // todo: need to fix null
      future: _getUsername(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String ident = " ";
        String firstName = " ";
        String lastName = " ";

        if (snapshot.data != null) {
          ident = snapshot.data.ident;
          firstName = snapshot.data.firstName;
          lastName = snapshot.data.lastName;
        }

        return UserAccountsDrawerHeader(
          accountEmail: Text(ident),
          accountName: Text("$firstName $lastName"),
          currentAccountPicture: CircleAvatar(
            child: Text(firstName[0] + lastName[0]),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
        );
      },
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap, int pos}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: selectedList[pos] == true ? Colors.red : Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
      selected: selectedList[pos],
    );
  }

  Future<Profile> _getUsername() async {
    return await widget.profileDao.getProfile();
  }
}
