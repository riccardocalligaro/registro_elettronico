import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/about_app_dialog.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/presentation/help_page.dart';
import 'package:registro_elettronico/feature/debug/presentation/debug_page.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart';
import 'package:registro_elettronico/feature/settings/widgets/about/about_developers_page.dart';
import 'package:registro_elettronico/feature/settings/widgets/account/account_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/customization/customization_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/general/general_settings.dart';
import 'package:registro_elettronico/feature/settings/widgets/header_text.dart';
import 'package:registro_elettronico/utils/bug_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences? sharedPrefs;

  bool _showDebug = false;

  @override
  void initState() {
    super.initState();

    ProfilesLocalDatasource profilesLocalDatasource = sl();
    final profile = profilesLocalDatasource.getLoggedInUserSync();

    // My personal ident
    if (profile.ident == 'S6102171X') {
      setState(() {
        _showDebug = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context)!.translate('settings')!,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_showDebug || kDebugMode)
                ListTile(
                  title: Text('Debug'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DebugPage(),
                    ));
                  },
                ),

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
    final trans = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context)!.translate('about_title'),
          ),
        ),
        ListTile(
          title: Text(trans.translate('about_developers_title')!),
          subtitle: Text(trans.translate('about_developers_subtitle')!),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutDevelopersPage()));
          },
        ),
        ListTile(
          title: Text(
              AppLocalizations.of(context)!.translate('report_bug_title')!),
          subtitle: Text(
              AppLocalizations.of(context)!.translate('report_bug_message')!),
          onTap: () async {
            await ReportManager.sendEmail(context);
          },
        ),
        // DonateTile(),
        ListTile(
          title: Text(trans.translate('info_app_title')!),
          subtitle: Text(trans.translate('info_app_subtitle')!),
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
        ListTile(
          title: Text(trans.translate('help_page_title')!),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HelpPage(
                  fromSettings: true,
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
