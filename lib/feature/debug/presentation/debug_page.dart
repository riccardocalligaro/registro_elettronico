import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/notification/fcm_service.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  static const platform =
      MethodChannel('com.riccardocalligaro.registro_elettronico/multi-account');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug mode'),
      ),
      body: Column(
        children: <Widget>[
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
              print(profile.toString());
            },
          ),
          DebugButton(
            title: 'Open DB',
            onTap: () {
              final AppDatabase db = sl();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
            },
          ),
          DebugButton(
            title: 'Current db name',
            onTap: () {
              final SharedPreferences sharedPreferences = sl();
              final dbName =
                  sharedPreferences.getString(PrefsConstants.databaseName);

              print(dbName);
            },
          ),
          DebugButton(
            title: 'Reset DB',
            dangerous: true,
            context: context,
            onTap: () async {
              final AppDatabase db = sl();
              await db.resetDb();
            },
          ),
          DebugButton(
            title: 'Get all profiles',
            onTap: () async {
              final ProfilesLocalDatasource profilesLocalDatasource = sl();
              final profiles = await profilesLocalDatasource.getAllProfiles();

              final FlutterSecureStorage flutterSecureStorage = sl();
              final psw = await flutterSecureStorage.read(key: 'X5605613Y');
              print(psw);
              // 5605613 X5605613Y
              print(profiles);
            },
          ),
          DebugButton(
            title: 'Clear shared preferences',
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
    Widget cancelButton = FlatButton(
      child: Text("Nope"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Yup"),
      onPressed: callback,
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
