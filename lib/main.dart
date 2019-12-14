import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/simple_bloc_delegate.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';
import 'package:registro_elettronico/ui/global/localizations/localizations_delegates.dart';
import 'package:registro_elettronico/ui/global/themes/theme_data/default_theme.dart';

import 'component/bloc_delegate.dart';
import 'component/routes.dart';

void main() {
  initApp();
  runApp(MyApp());
}

void initApp() {
  AppInjector.init();
  BlocSupervisor.delegate = SimpleBlocDelegate();
}

/// Registro elettronico by Riccardo Calligaro
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: AppBlocDelegate.instance(context).repositoryProviders,
      child: MultiBlocProvider(
        providers: AppBlocDelegate.instance(context).blocProviders,
        child: MaterialApp(
          title: "Registro elettronico",
          theme: defaultTheme,
          supportedLocales: LocalizationsDelegates.instance.supportedLocales,
          localeResolutionCallback:
              LocalizationsDelegates.instance.localeResolutionCallback,
          localizationsDelegates:
              LocalizationsDelegates.instance.localizationsDelegates,
          routes: Routes.routes,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        ),
      ),
    );
  }
}
