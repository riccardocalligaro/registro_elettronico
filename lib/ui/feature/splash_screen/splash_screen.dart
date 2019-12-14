import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _alreadyInit = false;

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

  void _autoSignIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AutoSignIn());
  }
}
