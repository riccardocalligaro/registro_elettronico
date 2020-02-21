import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';
import 'package:registro_elettronico/ui/feature/intro/components/download_liquid_circle.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettings extends StatefulWidget {
  AccountSettings({Key key}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context).translate('account'),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('reset_data')),
          subtitle: Text(
              AppLocalizations.of(context).translate('reset_data_message')),
          onTap: () {
            showDialog(context: context, builder: (context) => ResetDialog());
          },
        )
      ],
    );
  }
}

class ResetDialog extends StatelessWidget {
  const ResetDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('reset_db_alert')),
      content: Text(
        AppLocalizations.of(context).translate('reset_db_alert_message'),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('no')),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('yes')),
          onPressed: () async {
            AppDatabase().resetDbWithoutProfile();
            SharedPreferences prefs = Injector.appInstance.getDependency();
            prefs.setBool(PrefsConstants.VITAL_DATA_DOWNLOADED, false);
            BlocProvider.of<IntroBloc>(context).add(FetchAllData());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: IntroDownloadLiquidCircle(),
                  ),
                ),
              ),
            );

            //Navigator.pop(context);
          },
        )
      ],
    );
  }
}
