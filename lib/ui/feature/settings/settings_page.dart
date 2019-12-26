import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/ui/feature/settings/components/account/account_settings.dart';
import 'package:registro_elettronico/ui/feature/settings/components/customization/customization_settings.dart';
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
        position: DrawerConstants.SETTINGS,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Notification settins
              _buildNotificationsSettingsSection(),

              /// General settings
              GeneralSettings(),

              CustomizationSettings(),

              AccountSettings()
            ],
          ),
        ),
      ),
    );
  }

  /// Notifcation settings, you can set [what] to notify, the interval, and chose if wifi and battery options
  Widget _buildNotificationsSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context).translate('notifications'),
          ),
        ),
        ListTile(
          title: Text(
              AppLocalizations.of(context).translate('choose_what_to_notify')),
          subtitle: Text(
            AppLocalizations.of(context)
                .translate('press_to_set_notifications'),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return SimpleDialog(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 100,
                      child: NotificationsSettingsDialog(),
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).translate('choose_interval'),
          ),
          subtitle: Text(_getUpdateTimeMessage(_updateInterval)),
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

  String _getUpdateTimeMessage(int interval) {
    if (interval >= 60)
      return AppLocalizations.of(context)
          .translate('every_hours')
          .replaceAll('{h}', (interval / 60).toString());
    return AppLocalizations.of(context)
        .translate('every_minutes')
        .replaceAll('{m}', interval.toString());
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
