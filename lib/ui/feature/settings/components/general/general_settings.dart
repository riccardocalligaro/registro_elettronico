import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/ui/feature/settings/components/general/general_sorting_settings_dialog.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../header_text.dart';
import 'general_objective_settings_dialog.dart';

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
  bool _updateAtStart = false;

  @override
  void initState() {
    restore();
    super.initState();
  }

  restore() async {
    SharedPreferences sharedPrefs = Injector.appInstance.getDependency();
    setState(() {
      _sliderValue =
          (sharedPrefs.getInt(PrefsConstants.OVERALL_OBJECTIVE)) ?? 6;

      // _periodAveragesHomeScreen =
      //     (sharedPrefs.getInt(PrefsConstants.PERIOD_TO_SHOW)) ??
      //         TabsConstants.GENERALE;

      _updateAtStart =
          (sharedPrefs.getBool(PrefsConstants.UPDATE_AT_START) ?? false);
      _ascending =
          (sharedPrefs.getBool(PrefsConstants.SORTING_ASCENDING)) ?? false;
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
          title: Text(AppLocalizations.of(context).translate('your_objective')),
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
                SharedPreferences preferences =
                    Injector.appInstance.getDependency();
                setState(() {
                  _sliderValue = value;
                  preferences.setInt(PrefsConstants.OVERALL_OBJECTIVE, value);
                });
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
              }

              SharedPreferences sharedPreferences =
                  Injector.appInstance.getDependency();
              sharedPreferences.setBool(
                  PrefsConstants.SORTING_ASCENDING, value);
            });
          },
        ),
        ListTile(
          title: Text(
              AppLocalizations.of(context).translate('update_at_start_title')),
          trailing: Checkbox(
            value: _updateAtStart ?? false,
            onChanged: (value) async {
              setState(() {
                _updateAtStart = value;
              });

              SharedPreferences prefs = Injector.appInstance.getDependency();
              prefs.setBool(PrefsConstants.UPDATE_AT_START, value);
            },
          ),
        )
      ],
    );
  }
}
