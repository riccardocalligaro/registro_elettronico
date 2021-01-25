import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/about_app_dialog.dart';
import 'package:registro_elettronico/feature/settings/widgets/about/about_developers_page.dart';
import 'package:registro_elettronico/feature/settings/widgets/account/account_settings.dart';
import 'package:registro_elettronico/utils/bug_report.dart';

class HelpPage extends StatelessWidget {
  final bool fromSettings;
  const HelpPage({
    Key key,
    this.fromSettings = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('help_page_title')),
      ),
      body: ExpandableTheme(
        data: ExpandableThemeData(
          tapHeaderToExpand: true,
          hasIcon: true,
          iconColor: Theme.of(context).iconTheme.color,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
        ),
        child: ListView(
          children: [
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_1_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SelectableText(
                  AppLocalizations.of(context).translate('faq_1_a'),
                ),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_2_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(AppLocalizations.of(context).translate('faq_2_a')),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_3_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(AppLocalizations.of(context).translate('faq_3_a')),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_4_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_4_a'),
                ),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_5_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SelectableText(
                  AppLocalizations.of(context).translate('faq_5_a'),
                ),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).translate('faq_6_q'),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SelectableText(
                  AppLocalizations.of(context).translate('faq_6_a'),
                ),
              ),
            ),
            if (!fromSettings)
              ListTile(
                title: Text(AppLocalizations.of(context)
                    .translate('about_developers_title')),
                subtitle: Text(AppLocalizations.of(context)
                    .translate('about_developers_subtitle')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutDevelopersPage(),
                    ),
                  );
                },
              ),
            if (!fromSettings)
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('report_bug_title')),
                subtitle: Text(AppLocalizations.of(context)
                    .translate('report_bug_message')),
                onTap: () async {
                  await ReportManager.sendEmail(context);
                },
              ),
            if (!fromSettings)
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('info_app_title')),
                subtitle: Text(AppLocalizations.of(context)
                    .translate('info_app_subtitle')),
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
            if (!fromSettings)
              ListTile(
                title:
                    Text(AppLocalizations.of(context).translate('reset_data')),
                subtitle: Text(AppLocalizations.of(context)
                    .translate('reset_data_message')),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ResetDialog(),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
