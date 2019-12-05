import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

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
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  LoginRepository loginRepo =
                      LoginRepositoryImpl(Injector.appInstance.getDependency());
                  final response = await loginRepo.signIn(username: 'rikybraun', password: 'ciao123');
                  // print(response.statusCode);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
