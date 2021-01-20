import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/about_app_dialog.dart';
import 'package:registro_elettronico/feature/settings/widgets/about/about_developers_page.dart';
import 'package:registro_elettronico/feature/settings/widgets/account/account_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/customization/customization_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/general/general_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/header_text.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context).translate('settings'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// General settings
              GeneralSettings(),

              CustomizationSettings(),

              AccountSettings(),

              _buildAboutSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    final trans = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context).translate('about_title'),
          ),
        ),
        ListTile(
          title: Text(trans.translate('about_developers_title')),
          subtitle: Text(trans.translate('about_developers_subtitle')),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutDevelopersPage()));
          },
        ),
        ListTile(
          title:
              Text(AppLocalizations.of(context).translate('report_bug_title')),
          subtitle: Text(
              AppLocalizations.of(context).translate('report_bug_message')),
          onTap: () async {
            await FLog.exportLogs();
            final path = await _localPath + "/" + PrefsConstants.DIRECTORY_NAME;

            final random = GlobalUtils.getRandomNumber();
            final subject =
                'Bug report #$random - ${DateTime.now().toString()}';
            String userMessage = '';
            final packageInfo = await PackageInfo.fromPlatform();
            userMessage +=
                "Versione app: ${packageInfo.version}+${packageInfo.buildNumber}";

            userMessage += "\nPiattaforma: ${Platform.operatingSystem}\n";
            userMessage +=
                '${AppLocalizations.of(context).translate("email_message")}\n  -';

            final Email reportEmail = Email(
              body: userMessage,
              subject: subject,
              recipients: ['registroelettronico.mobileapp@gmail.com'],
              attachmentPaths: ['$path/flog.txt'],
              isHTML: false,
            );
            await FlutterEmailSender.send(reportEmail);
          },
        ),
        // DonateTile(),
        ListTile(
          title: Text(trans.translate('info_app_title')),
          subtitle: Text(trans.translate('info_app_subtitle')),
          onTap: () async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            await showDialog(
              context: context,
              builder: (context) => AboutAppDialog(
                packageInfo: packageInfo,
              ),
            );
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Future<String> get _localPath async {
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory.path;
  }
}
