import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/main.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class IntroDownloadLiquidCircle extends StatefulWidget {
  IntroDownloadLiquidCircle({Key key}) : super(key: key);

  @override
  _IntroDownloadLiquidCircleState createState() =>
      _IntroDownloadLiquidCircleState();
}

class _IntroDownloadLiquidCircleState extends State<IntroDownloadLiquidCircle>
    with SingleTickerProviderStateMixin {
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroInitial) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 2.80,
                child: GestureDetector(
                  onTap: () async {
                    BlocProvider.of<IntroBloc>(context).add(FetchAllData());
                  },
                  child: LiquidCircularProgressIndicator(
                    value: 0.0,
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                    backgroundColor: Colors.white,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_downward,
                          size: 84,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('download'),
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        )
                      ],
                    ), // Defaults to the current Theme's backgroundColor.
                  ),
                ),
              );
            }
            if (state is IntroLoading) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 2.80,
                child: LiquidCircularProgressIndicator(
                  value: state.progress / 100,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                ),
              );
            }
            if (state is IntroLoaded) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 2.80,
                child: GestureDetector(
                  onTap: () async {
                    FLog.info(
                        text: 'Checking shared prefrences for notifications!');
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    final notifyGrades =
                        prefs.getBool(PrefsConstants.GRADES_NOTIFICATIONS) ??
                            false;
                    final notifyAgenda =
                        prefs.getBool(PrefsConstants.AGENDA_NOTIFICATIONS) ??
                            false;
                    final notifyAbsenes =
                        prefs.getBool(PrefsConstants.AGENDA_NOTIFICATIONS) ??
                            false;
                    final notifyNotes =
                        prefs.getBool(PrefsConstants.NOTES_NOTIFICATIONS) ??
                            false;

                    if (notifyGrades ||
                        notifyNotes ||
                        notifyAgenda ||
                        notifyAbsenes) {
                      prefs.setBool(PrefsConstants.NOTIFICATIONS, true);
                      WidgetsFlutterBinding.ensureInitialized();
                      Workmanager.cancelAll();
                      Workmanager.initialize(
                        callbackDispatcher,
                        //! set to false in production
                        isInDebugMode: true,
                      );

                      Workmanager.registerPeriodicTask(
                        'checkForNewContent', 'checkForNewContent',
                        initialDelay: Duration(minutes: 60),
                        // minimum frequency for android is 15 minutes
                        frequency: Duration(minutes: 30),
                        constraints: Constraints(
                          networkType: NetworkType.unmetered,
                          requiresBatteryNotLow: true,
                        ),
                      );
                      FLog.info(text: 'Set everything for periodic task!');
                    } else {
                      prefs.setBool(PrefsConstants.NOTIFICATIONS, false);
                      FLog.info(text: 'No notifications set!');
                    }

                    AppNavigator.instance.navToHome(context);
                  },
                  child: LiquidCircularProgressIndicator(
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Colors.white,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          size: 84,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('press_here'),
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ), // Defaults to the current Theme's backgroundColor.
                  ),
                ),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.height / 2.80,
              child: LiquidCircularProgressIndicator(
                value: 0.0,
                valueColor: AlwaysStoppedAnimation(Colors.red),
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
              ),
            );
          },
        ),
      ],
    );
  }
}
