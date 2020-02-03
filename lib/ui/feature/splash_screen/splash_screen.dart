import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/periods_bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _alreadyInit = false;
  int _lastUpdateVitalData;

  @override
  void initState() {
    restore();
    super.initState();
  }

  void restore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastUpdateVitalData = prefs.getInt(PrefsConstants.LAST_UPDATE_VITAL_DATA);

    if (_lastUpdateVitalData != null) {
      FLog.info(
          text:
              'Last update vital data is not null, need to check last update');
      _updateVitalData(_lastUpdateVitalData);
    } else {
      FLog.info(
          text: 'Last update vital data is null, no need to check last update');
    }
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
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          /// Checks if the autosign in returns the positive result that the user is
          /// auto signed in, so it redirects to the Home page

          if (state is AutoSignInResult) {
            FLog.info(text: "Auto sign in resulted -> Home screen");
            //AppNavigator.instance.navToLogin(context);
            //AppNavigator.instance.navToIntro(context);
            AppNavigator.instance.navToHome(context);
          }

          /// If the auto sign in returns an error the user
          /// is redirected to the login page
          else if (state is AutoSignInError) {
            FLog.info(text: "Auto sign in error -> Login screen screen");
            AppNavigator.instance.navToLogin(context);
          } else if (state is AutoSignInNeedDownloadData) {
            AppNavigator.instance.navToIntro(context);
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

  void _updateVitalData(int lastUpdateVitalData) async {
    // We have to check if the school year started

    final now = DateTime.now();
    int yearBegin = now.year;

    // if we are before sempember we need to fetch from the last year
    if (now.month < DateTime.september) {
      yearBegin -= 1;
    }

    final DateTime beginDate = DateTime.utc(yearBegin, DateTime.september, 1);

    if (DateTime.fromMillisecondsSinceEpoch(lastUpdateVitalData)
        .isBefore(beginDate)) {
      // Update vital data
      BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
      BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());

      FLog.info(text: 'Updated vital data (subjects & periods)');

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setInt(PrefsConstants.LAST_UPDATE_VITAL_DATA,
          DateTime.now().millisecondsSinceEpoch);
    } else {
      FLog.info(text: 'No need to update');
    }
  }
}
