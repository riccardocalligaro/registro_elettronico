import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/change_account_dialog.dart';
import 'package:registro_elettronico/feature/debug/presentation/debug_page.dart';
import 'package:registro_elettronico/feature/settings/widgets/header_text.dart';
import 'package:registro_elettronico/feature/web/presentation/spaggiari_web_view.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: HeaderText(
              text: AppLocalizations.of(context).translate('general'),
            ),
          ),
          if (kDebugMode)
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Debug'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DebugPage(),
                ));
              },
            ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text(
              AppLocalizations.of(context).translate('lessons'),
            ),
            onTap: () {
              AppNavigator.instance.navToLessons(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text(
              AppLocalizations.of(context).translate('school_material'),
            ),
            onTap: () {
              AppNavigator.instance.navToSchoolMaterial(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text(
              AppLocalizations.of(context).translate('absences'),
            ),
            onTap: () {
              AppNavigator.instance.navToAbsences(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              AppLocalizations.of(context).translate('notes'),
            ),
            onTap: () {
              AppNavigator.instance.navToNotes(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              AppLocalizations.of(context).translate('timetable'),
            ),
            onTap: () {
              AppNavigator.instance.navToTimetable(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.import_contacts),
            title: Text(
              AppLocalizations.of(context).translate('scrutini'),
            ),
            onTap: () {
              AppNavigator.instance.navToScrutini(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text(
              AppLocalizations.of(context).translate('statistics'),
            ),
            onTap: () {
              AppNavigator.instance.navToStats(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text(
              AppLocalizations.of(context).translate('web'),
            ),
            onTap: () {
              final url =
                  'https://web.spaggiari.eu/home/app/default/login.php?index.php';
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SpaggiariWebView(
                    appBarTitle: AppLocalizations.of(context).translate('web'),
                    url: url,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: HeaderText(
              text: AppLocalizations.of(context).translate('other_section'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context).translate('settings'),
            ),
            onTap: () {
              AppNavigator.instance.navToSettings(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text(
              AppLocalizations.of(context).translate('change_account'),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ChangeAccountDialog(),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              AppLocalizations.of(context).translate('logout'),
            ),
            onTap: () async {
              // TODO: add dialog
              final AuthenticationRepository authenticationRepository = sl();
              await authenticationRepository.logoutCurrentUser();
            },
          ),
        ],
      ),
    );
  }
}
