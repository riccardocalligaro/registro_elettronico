import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/notifications/notification_service.dart';
import 'package:registro_elettronico/component/simple_bloc_delegate.dart';
import 'package:registro_elettronico/ui/application.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';
import 'package:workmanager/workmanager.dart';

import 'component/routes.dart';

FlutterLocalNotificationsPlugin globalLocalNotifications;

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    await NotificationService().checkForNewContent();
    return Future.value(true);
  });
}

void main() {
  initApp();
  // Finnaly run the app
  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (Object error, Object stackTrace) {
    FLog.error(
      text: 'Exception',
      exception: error,
      stacktrace: stackTrace,
    );

    Crashlytics.instance.recordError(error, stackTrace);
  });
}

void initApp() {
  // Init the dependency injection -> compile-time dependency injection for Dart and Flutter, similar to Dagger.
  AppInjector.init();

  //initLocalNotifications();

  // BloC supervisor delegate to show all the different states of the bloc
  BlocSupervisor.delegate = SimpleBlocDelegate();

  Crashlytics.instance.enableInDevMode = false;
}

/// Registro elettronico by Riccardo Calligaro
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      builder: (bCtx, initData) {
        _setSystemUI(initData.materialThemeData.brightness);
        return MaterialApp(
          title: 'Registro elettronico',
          locale: initData.locale,
          theme: initData.materialThemeData,
          supportedLocales: initData.supportedLocales,
          localizationsDelegates: initData.localizationsDelegates,
          localeResolutionCallback: initData.localeResolutionCallback,
          //debugShowCheckedModeBanner: false,
          routes: Routes.routes,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }

  _setSystemUI(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
  }
}
