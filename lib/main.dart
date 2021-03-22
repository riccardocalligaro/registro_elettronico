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
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/splash/presentation/splash_screen.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:time_machine/time_machine.dart';

import 'core/data/remote/api/sr_dio_client.dart';
import 'core/infrastructure/log/logger.dart';
import 'core/infrastructure/log/logger_bloc.dart';
import 'core/infrastructure/notification/fcm_service.dart';
import 'core/infrastructure/routes.dart';

FlutterLocalNotificationsPlugin globalLocalNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize time machine for the timetable library
  await TimeMachine.initialize({'rootBundle': rootBundle});

  await Firebase.initializeApp();

  // Dependency injection
  await CoreContainer.init();

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
  Bloc.observer = LoggerBlocDelegate();

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
          // debugShowCheckedModeBanner: false,
          builder: (context, child) => ResponsiveWrapper.builder(
            child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: false,
            breakpoints: [
              ResponsiveBreakpoint.autoScale(
                700,
                name: TABLET,
                scaleFactor: 1.15,
              ),
              ResponsiveBreakpoint.autoScale(
                900,
                name: DESKTOP,
                scaleFactor: 1.3,
              ),
            ],
          ),
          routes: Routes.routes,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }
}
