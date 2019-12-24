import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class LocalNotificationWidget extends StatefulWidget {
  LocalNotificationWidget({Key key}) : super(key: key);

  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static const CHANNEL_ID = "com.registroelettronico/notification";
  static const CHANNEL_NAME = "Registro elettronico";
  static const CHANNEL_DESCRIPTION = "Send and receiver notifications";

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  showNotification(int id, String title, String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      AppLocalizations.of(context).translate(title),
      message,
      platformChannelSpecifics,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
