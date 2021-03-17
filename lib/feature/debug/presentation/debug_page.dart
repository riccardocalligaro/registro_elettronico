import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/notification/fcm_service.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/utils/bug_report.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logs_page.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  static const platform =
      MethodChannel('com.riccardocalligaro.registro_elettronico/multi-account');

  String dbName = '';
  String profiles = '';

  @override
  void initState() {
    final SharedPreferences sharedPreferences = sl();
    final _dbName = sharedPreferences.getString(PrefsConstants.databaseName);
    setState(() {
      dbName = _dbName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug mode'),
      ),
      body: ListView(
        children: <Widget>[
          SectionDivider(text: '📝 Logs'),
          DebugButton(
            title: 'Send logs',
            onTap: () {
              ReportManager.sendEmail(context);
            },
          ),
          DebugButton(
            title: 'View logs',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LogsPage(),
              ));
            },
          ),
          SectionDivider(text: '🔒 Authentication'),
          DebugButton(
            title: 'Cancel token',
            onTap: () async {
              final AuthenticationRepository authenticationRepository = sl();
              final profile = await authenticationRepository.getProfile();

              await authenticationRepository.updateProfile(
                responseRemoteModel: DefaultLoginResponseRemoteModel(
                  ident: profile.ident,
                  firstName: profile.firstName,
                  lastName: profile.lastName,
                  token: profile.token,
                  release: DateTime.now()
                      .subtract(Duration(days: 2))
                      .toIso8601String(),
                  expire: DateTime.now()
                      .subtract(Duration(days: 2))
                      .toIso8601String(),
                ),
                profileDomainModel: profile,
              );
            },
          ),
          SectionDivider(text: '🗄️ Database'),
          DebugButton(
            title: 'Open DB',
            onTap: () {
              final SRDatabase db = sl();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
            },
          ),
          DebugButton(
            title: 'Current database name',
            subtitle: dbName,
            onTap: () {
              final SharedPreferences sharedPreferences = sl();
              final dbName =
                  sharedPreferences.getString(PrefsConstants.profile);

              print(dbName);
            },
          ),
          DebugButton(
            title: 'Get all profiles',
            onTap: () async {
              final ProfilesLocalDatasource profilesLocalDatasource = sl();
              final _profiles = await profilesLocalDatasource.getAllProfiles();
              setState(() {
                profiles = _profiles.toString();
              });
              Logger.info(profiles.toString());
            },
          ),
          if (profiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(profiles),
            ),
          SectionDivider(text: '📚 Other'),
          DebugButton(
            title: 'Send notification',
            subtitle: 'With the local notifications plugin',
            onTap: () async {
              AndroidInitializationSettings androidInitializationSettings =
                  AndroidInitializationSettings('app_icon');

              var initializationSettingsIOS = IOSInitializationSettings(
                requestSoundPermission: false,
                requestBadgePermission: false,
                requestAlertPermission: false,
              );

              var initializationSettings = InitializationSettings(
                android: androidInitializationSettings,
                iOS: initializationSettingsIOS,
              );

              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();

              await flutterLocalNotificationsPlugin
                  .initialize(initializationSettings);

              var androidPlatformChannelSpecifics = AndroidNotificationDetails(
                PushNotificationService.channelId,
                PushNotificationService.channelName,
                PushNotificationService.channelDescription,
                importance: Importance.max,
                priority: Priority.high,
              );

              var iOSPlatformChannelSpecifics = IOSNotificationDetails();
              var platformChannelSpecifics = NotificationDetails(
                android: androidPlatformChannelSpecifics,
                iOS: iOSPlatformChannelSpecifics,
              );

              await flutterLocalNotificationsPlugin.show(
                0,
                'Title',
                'Notification body',
                platformChannelSpecifics,
              );
            },
          ),
          SectionDivider(
            text: '⚠️  Danger zone',
            textColor: Colors.white,
            color: Colors.red,
          ),
          DebugButton(
            title: 'Clear shared preferences',
            dangerous: true,
            context: context,
            onTap: () async {
              final SharedPreferences sharedPreferences = sl();
              await sharedPreferences.clear();
            },
          ),
          DebugButton(
            title: 'Crash and restart',
            dangerous: true,
            context: context,
            onTap: () {
              platform.invokeMethod('restartApp');
            },
          ),
          DebugButton(
            title: 'Reset DB',
            dangerous: true,
            context: context,
            onTap: () async {
              final SRDatabase db = sl();
              await db.resetDb();
            },
          ),
        ],
      ),
    );
  }
}

class DebugButton extends ListTile {
  final BuildContext context;
  final bool dangerous;

  DebugButton({
    @required String title,
    String subtitle,
    @required VoidCallback onTap,
    this.context,
    this.dangerous = false,
  })  : assert(!dangerous || context != null),
        super(
          onTap: (dangerous) ? () => safe(context, onTap) : onTap,
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
        );

  static void safe(BuildContext context, VoidCallback callback) {
    Widget cancelButton = TextButton(
      child: Text("Nope"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text("Yup"),
      onPressed: () {
        callback();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Attention!"),
      content: Text("Are you sure you want to do this?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class SectionDivider extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const SectionDivider({
    Key key,
    @required this.text,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      color: color ?? Theme.of(context).accentColor.withOpacity(0.4),
    );
  }
}
