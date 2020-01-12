import 'package:f_logs/model/flog/flog.dart';
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
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_alreadyInit) {
      _alreadyInit = true;
      _autoSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          /// Checks if the autosign in returns the positive result that the user is
          /// auto signed in, so it redirects to the Home page
          if (state is AutoSignInResult) {
            FLog.info(text: "Auto sign in resulted -> Home screen");
            AppNavigator.instance.navToHome(context);
          }

          /// If the auto sign in returns an error the user
          /// is redirected to the login page
          if (state is AutoSignInError) {
            FLog.info(text: "Auto sign in error -> Login screen screen");
            AppNavigator.instance.navToLogin(context);
          }
        },
        child: Center(
          child: Icon(
            Icons.school,
            color: Theme.of(context).accentColor,
            size: 64.0,
          ),
        ),
      ),
    );
  }

  void _autoSignIn(BuildContext context) {
    FLog.info(
      text: "Checking if user is signed in, adding auto sign in to BloC",
    );
    BlocProvider.of<AuthBloc>(context).add(AutoSignIn());
  }
}
