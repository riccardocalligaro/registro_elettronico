import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/routes.dart';
import 'package:registro_elettronico/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';

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
    return MaterialApp(
      title: 'School dairy',
      routes: Routes.routes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => LoginPage());
      },
    );
  }
}
