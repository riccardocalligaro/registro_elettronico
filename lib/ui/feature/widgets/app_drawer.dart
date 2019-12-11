import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  ProfileDao profileDao;
  AppDrawer({@required this.profileDao});

  @override
  Widget build(BuildContext context) {
    AppLocalizations trans = AppLocalizations.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: trans.translate("briefing"),
          ),
          _createDrawerItem(
            icon: Icons.library_books,
            text: trans.translate("lessons"),
          ),
          _createDrawerItem(
            icon: Icons.timeline,
            text: trans.translate("grades"),
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: trans.translate("agenda"),
          ),
          _createDrawerItem(
            icon: Icons.folder,
            text: trans.translate("school_material"),
          ),
          _createDrawerItem(
            icon: Icons.assessment,
            text: trans.translate("absences"),
          ),
          _createDrawerItem(
            icon: Icons.warning,
            text: trans.translate("notes"),
          ),
          _createDrawerItem(
            icon: Icons.assignment,
            text: trans.translate("notice_board"),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.settings,
            text: trans.translate("settings"),
          ),
          _createDrawerItem(
            icon: Icons.share,
            text: trans.translate("share"),
          ),
          _createDrawerItem(
            icon: Icons.send,
            text: trans.translate("contact_us"),
          ),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: "Logout",
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(SignOut());
                AppNavigator.instance.navToLogin(context);
              })
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return FutureBuilder(
      // todo: need to fix null
      future: _getUsername(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String ident = "";
        String name = "";

        if (snapshot.data != null) {
          ident = snapshot.data.ident;
          name = "${snapshot.data.firstName} ${snapshot.data.lastName}";
        }

        return UserAccountsDrawerHeader(
          accountEmail: Text(ident),
          accountName: Text(name),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
        );
      },
    );
  }

  Widget _createDrawerItem({
    IconData icon,
    String text,
    GestureTapCallback onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Future<Profile> _getUsername() async {
    return await profileDao.getProfile();
  }
}
