import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../header_text.dart';
import 'general_objective_settings_dialog.dart';
import 'general_sorting_settings_dialog.dart';

class GeneralSettings extends StatefulWidget {
  GeneralSettings({
    Key key,
  }) : super(key: key);

  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  int _sliderValue = 6;

  //int _periodAveragesHomeScreen;
  bool _ascending = false;
  int _class = 3;

  @override
  void initState() {
    restore();
    super.initState();
  }

  void restore() async {
    SharedPreferences sharedPrefs = sl();
    setState(() {
      _sliderValue = sharedPrefs.getInt(PrefsConstants.OVERALL_OBJECTIVE) ?? 6;

      _ascending =
          sharedPrefs.getBool(PrefsConstants.SORTING_ASCENDING) ?? false;
      _class = sharedPrefs.getInt(PrefsConstants.STUDENT_YEAR) ?? 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context).translate('general'),
          ),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).translate('your_objective'),
          ),
          subtitle: Text('$_sliderValue'),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                children: <Widget>[
                  GeneralObjectiveSettingsDialog(
                    objective: _sliderValue.toInt(),
                  )
                ],
              ),
            ).then((value) async {
              if (value != null) {
                SharedPreferences preferences = sl();
                setState(() {
                  _sliderValue = value;
                  preferences.setInt(PrefsConstants.OVERALL_OBJECTIVE, value);
                });
                BlocProvider.of<GradesWatcherBloc>(context)
                    .add(RestartWatcher());
              }
            });
          },
        ),
        // ListTile(
        //   title: Text(
        //     AppLocalizations.of(context)
        //         .translate('averages_to_show_in_the_home_screen'),
        //   ),
        //   subtitle: Text(
        //     _periodAveragesHomeScreen != TabsConstants.GENERALE
        //         ? ""
        //         : AppLocalizations.of(context).translate('general'),
        //   ),
        //   onTap: () async {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         return SimpleDialog(
        //           children: <Widget>[
        //             GeneralAveragesHomeSettings(
        //               period: _periodAveragesHomeScreen,
        //             )
        //           ],
        //         );
        //       },
        //     );
        //   },
        // ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).translate('sort_averages_by'),
          ),
          subtitle: Text(
            !_ascending
                ? AppLocalizations.of(context).translate('average_descending')
                : AppLocalizations.of(context).translate('average_ascending'),
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                children: <Widget>[
                  GeneralSortingSettingsDialog(
                    ascending: _ascending,
                  )
                ],
              ),
            ).then((value) async {
              if (value != null) {
                setState(() {
                  _ascending = value;
                });
                BlocProvider.of<GradesWatcherBloc>(context)
                    .add(RestartWatcher());
              }

              SharedPreferences sharedPreferences = sl();
              await sharedPreferences.setBool(
                  PrefsConstants.SORTING_ASCENDING, value);
            });
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('class_title')),
          subtitle:
              Text(AppLocalizations.of(context).translate('class_subtitle')),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return NumberPickerDialog.integer(
                  initialIntegerValue: _class,
                  minValue: 1,
                  maxValue: 5,
                  title: Text(
                      AppLocalizations.of(context).translate('class_title')),
                  cancelWidget: Text(AppLocalizations.of(context)
                      .translate('cancel')
                      .toUpperCase()),
                );
              },
            ).then((value) {
              if (value != null) {
                setState(() {
                  _class = value;
                });

                SharedPreferences prefs = sl();
                prefs.setInt(PrefsConstants.STUDENT_YEAR, value);
              }
            });
          },
        )
      ],
    );
  }
}
