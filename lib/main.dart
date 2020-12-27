import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/application.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/splash/presentation/splash_screen.dart';

// import 'component/firebase_notification_handler.dart';
import 'core/infrastructure/routes.dart';

FlutterLocalNotificationsPlugin globalLocalNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  AppInjector.init();

  runZonedGuarded(() {
    runApp(SrApp());
  }, (e, s) {
    FLog.error(
      text: 'Error!',
      exception: Exception(e.toString()),
      stacktrace: s,
    );
    FirebaseCrashlytics.instance.recordError(e, s);
  });
}

class SrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      builder: (bCtx, initData) {
        return MaterialApp(
          title: 'Registro elettronico',
          locale: initData.locale,
          theme: initData.materialThemeData,
          supportedLocales: initData.supportedLocales,
          localizationsDelegates: initData.localizationsDelegates,
          localeResolutionCallback: initData.localeResolutionCallback,
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          routes: Routes.routes,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }
}
