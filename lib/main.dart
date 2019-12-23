import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/simple_bloc_delegate.dart';
import 'package:registro_elettronico/ui/application.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';
import 'package:registro_elettronico/ui/global/localizations/localizations_delegates.dart';
import 'package:registro_elettronico/ui/global/theme/theme_data/default_theme.dart';

import 'component/bloc_delegate.dart';
import 'component/routes.dart';

void main() {
  // Set up eventual delegates, inits, etc.
  initApp();
  // Finnaly run the app
  runApp(MyApp());
}

void initApp() {
  // Init the dependency injection -> compile-time dependency injection for Dart and Flutter, similar to Dagger.
  AppInjector.init();
  // BloC supervisor delegate to show all the different states of the bloc
  BlocSupervisor.delegate = SimpleBlocDelegate();
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
//      statusBarIconBrightness: brightness,
//      statusBarBrightness: brightness,
    ));
  }
}
