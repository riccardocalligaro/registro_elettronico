import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/grades_bloc.dart';
import 'package:registro_elettronico/feature/lessons/presentation/bloc/lessons_bloc.dart';
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:registro_elettronico/feature/periods/presentation/bloc/periods_bloc.dart';
import 'package:registro_elettronico/feature/subjects/presentation/bloc/subjects_bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/update_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    _checkForUpdate();
  }

  void _checkForUpdate() async {
    // first we get the
    final SharedPreferences sharedPreferences = sl();

    if (_needUpdateAllData(sharedPreferences)) {
      // update all the endpoints
      await UpdateUtils.updateAllData();

      await sharedPreferences.setInt(PrefsConstants.lastUpdateAllData,
          DateTime.now().millisecondsSinceEpoch);
    } else {
      if (_needUpdate(sharedPreferences)) {
        BlocProvider.of<LessonsBloc>(context).add(UpdateTodayLessons());
        BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
        BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
        BlocProvider.of<GradesBloc>(context).add(GetGrades(limit: 3));

        await sharedPreferences.setInt(
            PrefsConstants.lastUpdate, DateTime.now().millisecondsSinceEpoch);
      }

      if (_needUpdateVitalData(sharedPreferences)) {
        BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
        BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());

        await sharedPreferences.setInt(PrefsConstants.lastUpdateVitalData,
            DateTime.now().millisecondsSinceEpoch);
      }
    }
  }

  bool _needUpdateAllData(SharedPreferences sharedPreferences) {
    final lastUpdate =
        sharedPreferences.getInt(PrefsConstants.lastUpdateAllData);
    return lastUpdate == null ||
        (DateTime.now().month == DateTime.september &&
            DateTime.fromMillisecondsSinceEpoch(lastUpdate)
                .isBefore(DateTime.now().subtract(Duration(days: 30)))) ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(days: 180)));
  }

  bool _needUpdateVitalData(SharedPreferences sharedPreferences) {
    final lastUpdate =
        sharedPreferences.getInt(PrefsConstants.lastUpdateVitalData);
    return lastUpdate == null ||
        (DateTime.now().month == DateTime.september &&
            DateTime.fromMillisecondsSinceEpoch(lastUpdate)
                .isBefore(DateTime.now().subtract(Duration(days: 1)))) ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(days: 30)));
  }

  bool _needUpdate(SharedPreferences sharedPreferences) {
    final lastUpdate = sharedPreferences.getInt(PrefsConstants.lastUpdate);
    return lastUpdate == null ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(minutes: 2)));
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
