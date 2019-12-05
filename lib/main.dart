import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_elettronico/api/login/login_api_service.dart';
import 'package:registro_elettronico/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => LoginApiService.create(),
      dispose: (context, LoginApiService service) => service.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LoginPage(),
      ),
    );
  }
}
