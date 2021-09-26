import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/settings/widgets/customization/color_settings_dialog.dart';

import '../header_text.dart';
import 'customization_theme_dialog.dart';

class CustomizationSettings extends StatefulWidget {
  CustomizationSettings({Key? key}) : super(key: key);

  @override
  _CustomizationSettingsState createState() => _CustomizationSettingsState();
}

class _CustomizationSettingsState extends State<CustomizationSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context)!.translate('customization'),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate('theme')!),
          subtitle:
              Text(AppLocalizations.of(context)!.translate('change_the_theme')!),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return SimpleDialog(
                  children: <Widget>[CustomizationSettingsThemeDialog()],
                );
              },
            );
          },
        ),
        ListTile(
          title:
              Text(AppLocalizations.of(context)!.translate('theme_color_title')!),
          subtitle: Text(
              AppLocalizations.of(context)!.translate('theme_color_subtitle')!),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return SimpleDialog(
                  children: <Widget>[ColorSettingsDialog()],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
