import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static const CHANNEL_ID = "com.registroelettronico/notification";
  static const CHANNEL_NAME = "Registro elettronico";
  static const CHANNEL_DESCRIPTION = "Send and receive notifications";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotification(
    Future onSelectNotification(String payload), {
    String icon,
  }) {
    var initializationSettingsAndroid =
        AndroidInitializationSettings(icon ?? 'app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future showNotificationWithDefaultSound(
    int id,
    String title,
    String message, {
    String payload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      message,
      platformChannelSpecifics,
      payload: payload ?? "Default_Sound",
    );
  }

  Future showNotificationWithoutSound(
    String title,
    String message, {
    String payload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: payload ?? 'No_Sound',
    );
  }

  Future scheduleNotification({
    @required int eventId,
    @required String title,
    @required String message,
    @required DateTime scheduledTime,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
        importance: Importance.Default, priority: Priority.Default);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      eventId,
      title,
      message,
      scheduledTime,
      platformChannelSpecifics,
    );
  }
}
