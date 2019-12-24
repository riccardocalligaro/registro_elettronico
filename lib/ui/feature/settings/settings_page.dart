import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logging/logging.dart';

import 'notifications_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(
          AppLocalizations.of(context).translate('settings'),
        ),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.SETTINGS,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildNotificationsSettingsSection(),
                _buildGeneralSettingSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderText(text: 'Notifications',),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Cosa notificare'),
          subtitle: Text('Tocca per impostare le notifiche'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => NotificationsSettingsPage(),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildGeneralSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderText(
          text: 'General',
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text('Your objective'),
          subtitle: Text('5'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                children: <Widget>[
                  Text('hello'),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
