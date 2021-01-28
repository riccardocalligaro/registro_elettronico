import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/presentation/custom/no_animation_route.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/login_page.dart';
import 'package:registro_elettronico/feature/navigator/navigator_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  void _checkAuthentication() async {
    final AuthenticationRepository authenticationRepository = sl();
    final authenticated = await authenticationRepository.isLoggedIn();

    if (authenticated) {
      await Navigator.of(context).pushReplacement(NoAnimationMaterialPageRoute(
        builder: (context) => NavigatorPage(
          fromLogin: true,
        ),
      ));
    } else {
      await Navigator.of(context).pushReplacement(NoAnimationMaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.school,
          color: Colors.red,
          size: 64.0,
        ),
      ),
    );
  }
}
