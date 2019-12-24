import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/ui/feature/settings/components/general/general_objective_settings_dialog.dart';
import 'package:registro_elettronico/ui/feature/settings/components/general/general_settings.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';
import 'package:registro_elettronico/ui/feature/settings/components/notifications/notifications_interval_settings_dialog.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/notifications/notifications_type_settings_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  int _updateInterval = 30;
  int _sliderValue = 6;
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _updateInterval =
          (sharedPrefs.getInt(PrefsConstants.UPDATE_INTERVAL)) ?? 30;
      _sliderValue =
          (sharedPrefs.getInt(PrefsConstants.OVERALL_OBJECTIVE)) ?? 6;
    });
  }

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
                GeneralSettings()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// General settings of the application
  Widget _buildGeneralSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderText(
          text: 'General',
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text('Il tuo obiettivo'),
          subtitle: Text('$_sliderValue'),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                children: <Widget>[
                  GeneralObjectiveSettingsDialog(
                    objective: _sliderValue.toInt(),
                  )
                ],
              ),
            ).then((value) {
              print(value);
              if (value != null) {
                setState(() {
                  _sliderValue = value;
                  save(PrefsConstants.OVERALL_OBJECTIVE, value);
                });
              }
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text('Medie da mostrare sulla schermata home'),
          subtitle: Text('$_sliderValue'),
          onTap: () async {},
        )
      ],
    );
  }

  /// Notifcation settings, you can set what to notify, the interval, and chose if wifi and battery options
  Widget _buildNotificationsSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderText(
          text: 'Notifications',
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Cosa notificare'),
          subtitle: Text('Tocca per impostare le notifiche'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return SimpleDialog(
                  children: <Widget>[
                    NotificationsSettingsDialog(),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Scegli intervallo'),
          subtitle: Text('Ogni $_updateInterval minuti'),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) {
                return SimpleDialog(
                  children: <Widget>[
                    NotificationsIntervalSettingsDialog(
                      updateInterval: _updateInterval,
                    ),
                  ],
                );
              },
            ).then((value) {
              setState(() {
                if (value != null) {
                  _updateInterval = value;
                  save(PrefsConstants.UPDATE_INTERVAL, value);
                }
              });
            });
          },
        ),
      ],
    );
  }

  static save(String key, dynamic value) async {
    Logger logger = Logger();
    logger.i('Changed value $key -> $value');
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
}
