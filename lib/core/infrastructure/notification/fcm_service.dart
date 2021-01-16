import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

class PushNotificationService {
  final FirebaseMessaging fcm;

  PushNotificationService(this.fcm);

  static const String progressPage = 'progress';
  static const String privacyPage = 'privacy';
  static const String membershipPage = 'membership';
  static const String settingsPage = 'settings';
  static const String changePasswordPage = 'changePassword';
  static const String searchPage = 'search';

  static const channelId = "com.registroelettronico/notification";
  static const channelName = "Registro elettronico";
  static const channelDescription = "Send and receive notifications";

  Future initialise() async {
    Logger.info('🔔 [FCM] Called initialisation...');

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    final token = await fcm.getToken();
    Logger.info("🔔 [FCM] Got token $token");

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Logger.info("🔔 [FCM] Got FCM Message $message");

        AndroidInitializationSettings androidInitializationSettings =
            AndroidInitializationSettings('ic_splash_logo');

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

        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onSelectNotification: _selectNotification,
        );

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics,
        );

        if (Platform.isIOS) {
          Logger.info('🔔 [FCM] Got message: $message');

          await flutterLocalNotificationsPlugin.show(
            _randomId(),
            message['aps']['alert']['title'] ?? '',
            message['aps']['alert']['body'] ?? '',
            platformChannelSpecifics,
          );
        } else if (Platform.isAndroid) {
          await flutterLocalNotificationsPlugin.show(
            _randomId(),
            message['notification']['title'],
            message['notification']['body'],
            platformChannelSpecifics,
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        Logger.info('🔔 [FCM] Launched push notification service $message');
      },
      onResume: (Map<String, dynamic> message) async {
        Logger.info('🔔 [FCM] Resumed push notification service $message');
      },
    );
  }

  int _randomId() {
    return Random().nextInt(10000) + 0;
  }

  void _selectNotification(String payload) {}
}
