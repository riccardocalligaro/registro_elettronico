import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/agenda/agenda_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/grades/grades_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/lessons/lessons_dashboard_bloc.dart'
    as dash;
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/update_utils.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _alreadyInit = false;

  @override
  void initState() {
    super.initState();

    // check if logged in
  }

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
    return Container(
      decoration: BoxDecoration(
          color: GlobalUtils.isDark(context) ? Colors.grey[900] : Colors.white),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          /// Checks if the autosign in returns the positive result that the user is
          /// auto signed in, so it redirects to the Home page
          if (state is AutoSignInResult) {
            FLog.info(text: "Auto sign in resulted -> Home screen");
            UpdateUtils.checkForUpdates(context);
            AppNavigator.instance.navToHome(context);
          }

          /// If the auto sign in returns an error the user
          /// is redirected to the login page
          else if (state is AutoSignInError) {
            FLog.info(text: "Auto sign in error -> Login screen screen");
            AppNavigator.instance.navToLogin(context);
          } else if (state is AutoSignInNeedDownloadData) {
            AppNavigator.instance.navToHome(context);
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
