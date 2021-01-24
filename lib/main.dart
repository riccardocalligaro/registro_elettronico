import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/application.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/splash/presentation/splash_screen.dart';
import 'package:time_machine/time_machine.dart';

import 'core/data/remote/api/dio_client.dart';
import 'core/infrastructure/log/logger.dart';
import 'core/infrastructure/log/logger_bloc.dart';
import 'core/infrastructure/notification/fcm_service.dart';
import 'core/infrastructure/routes.dart';
import 'feature/authentication/presentation/login_page.dart';

FlutterLocalNotificationsPlugin globalLocalNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TimeMachine.initialize({'rootBundle': rootBundle});

  await Firebase.initializeApp();

  await AppInjector.init();

  Bloc.observer = LoggerBlocDelegate();

  initApp();

  runZonedGuarded(() {
    runApp(SrApp());
  }, (e, s) {
    Logger.e(exception: e, stacktrace: s);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  });
}

void initApp() async {
  PushNotificationService pushNotificationService = sl();
  await pushNotificationService.initialise();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

class SrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      builder: (bCtx, initData) {
        return MaterialApp(
          navigatorKey: navigator,
          title: 'Registro elettronico',
          locale: initData.locale,
          theme: initData.materialThemeData,
          supportedLocales: initData.supportedLocales,
          localizationsDelegates: initData.localizationsDelegates,
          localeResolutionCallback: initData.localeResolutionCallback,
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          routes: Routes.routes,
          // home: LoginPage(),
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }
}
