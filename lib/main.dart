import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/notifications/notification_service.dart';
import 'package:registro_elettronico/component/simple_bloc_delegate.dart';
import 'package:registro_elettronico/ui/application.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';
import 'package:workmanager/workmanager.dart';

import 'package:logging/logging.dart';

import 'component/routes.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    await NotificationService().checkForNewContent();

    return Future.value(true);
  });
}

void main() {
  initApp();
  // Finnaly run the app
  runApp(MyApp());
}

void initApp() {
  // This is for the notification service
  setupLogging();

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  //Workmanager.registerOneOffTask("checkForNewContent", "checkForNewContent", initialDelay: Duration(seconds: 10));

  // Workmanager.registerPeriodicTask(
  //   "checkForNewContent",
  //   "checkForNewContent",
  //   // minimum is 15 minutes
  //   frequency: Duration(hours: 2),
  // );

  // Init the dependency injection -> compile-time dependency injection for Dart and Flutter, similar to Dagger.
  AppInjector.init();

  // BloC supervisor delegate to show all the different states of the bloc
  BlocSupervisor.delegate = SimpleBlocDelegate();
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
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
    ));
  }
}
