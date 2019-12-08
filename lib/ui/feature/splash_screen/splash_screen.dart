import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/home_page.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _alreadyInit = false;

  final String _myUsername = "S6102171X";
  final String _myPassword = "EB9O57aW5N0P6Fq6";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_alreadyInit) {
      _alreadyInit = true;
      _autoSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              /// Checks if the autosign in returns the positive result that the user is
              /// auto signed in, so it redirects to the Home page
              if (state is AutoSignInResult) {
                AppNavigator.instance.navToHome(context);
              }

              /// If the auto sign in returns an error the user is redirected to the
              /// login page
              if (state is AutoSignInError) {
                AppNavigator.instance.navToLogin(context);
              }
            },
            child: Center(
              child: Icon(
                Icons.school,
                color: Theme.of(context).accentColor,
                size: 64.0,
              ),
            )));
  }

  _signIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context)
        .add(SignIn(username: _myUsername, password: _myPassword));
  }

  void _autoSignIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AutoSignIn());
  }
}
