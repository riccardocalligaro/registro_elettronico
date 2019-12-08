import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/ui/bloc/authentication/authentication_state.dart';
import 'package:registro_elettronico/ui/feature/home/home_page.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splasch_screen.dart';
import 'package:registro_elettronico/ui/global/themes/theme_data/default_theme.dart';

import 'component/bloc_delegate.dart';
import 'ui/bloc/authentication/authentication_bloc.dart';

void main() {
  initApp();
  runApp(MyApp());
}

void initApp() {
  AppInjector.init();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: AppBlocDelegate.instance(context).repositoryProviders,
      child: MultiBlocProvider(
        providers: AppBlocDelegate.instance(context).blocProviders,
        child: MaterialApp(
          theme: defaultTheme,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationUninitialized) {
                return SplashPage();
              }
              if (state is AuthenticationAuthenticated) {
                return HomePage();
              }

              if (state is AuthenticationUnauthenticated) {
                return LoginPage();
              }

              if (state is AuthenticationLoading) {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        /*child: MaterialApp(
          title: 'School dairy',
          routes: Routes.routes,
          theme: defaultTheme,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => LoginPage());
          },
        ),*/
      ),
    );
  }
}
