import 'package:flutter/material.dart';
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
  int _updateInterval = 30;
  int _sliderValue = 6;

  @override
  void initState() {
    restore();
    super.initState();
  }

  restore() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _sliderValue =
          (sharedPrefs.getInt(PrefsConstants.OVERALL_OBJECTIVE)) ?? 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderText(
          text: AppLocalizations.of(context).translate('general'),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
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
                    await SharedPreferences.getInstance();
                setState(() {
                  _sliderValue = value;
                  preferences.setInt(PrefsConstants.OVERALL_OBJECTIVE, value);
                });
              }
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            AppLocalizations.of(context)
                .translate('averages_to_show_in_the_home_screen'),
          ),
          subtitle: Text('$_sliderValue'),
          onTap: () async {},
        )
      ],
    );
  }
}
