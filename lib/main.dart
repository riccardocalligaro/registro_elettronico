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

  // from firebase 0.5 +
  await Firebase.initializeApp();

  initApp();

  // Finnaly run the app
  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (Object error, Object stackTrace) {
    FLog.error(
      text: 'Error!',
      exception: Exception(error.toString()),
      stacktrace: stackTrace,
    );

    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

void initApp() {
  // Init the dependency injection -> compile-time dependency injection for Dart and Flutter, similar to Dagger.
  AppInjector.init();

  //initLocalNotifications();

  FirebaseCrashlytics.instance.enableInDevMode = false;

  // FirebaseNotifications().setUpFirebase();
}

/// Registro elettronico by Riccardo Calligaro
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      builder: (bCtx, initData) {
        // _setSystemUI(initData.overlayStyle);
        return MaterialApp(
          title: 'Registro elettronico',
          locale: initData.locale,
          theme: initData.materialThemeData,
          supportedLocales: initData.supportedLocales,
          localizationsDelegates: initData.localizationsDelegates,
          localeResolutionCallback: initData.localeResolutionCallback,
          debugShowCheckedModeBanner: false,
          routes: Routes.routes,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }

  // _setSystemUI(SystemUiOverlayStyle overlayStyle) {}
}
