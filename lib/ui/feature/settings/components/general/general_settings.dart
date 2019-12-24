import 'package:flutter/material.dart';
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
          text: 'General',
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text('Il tuo obiettivo'),
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
          title: Text('Medie da mostrare sulla schermata home'),
          subtitle: Text('$_sliderValue'),
          onTap: () async {},
        )
      ],
    );
  }
}
