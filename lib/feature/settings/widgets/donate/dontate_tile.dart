import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

import 'donate_dialog.dart';

class DonateTile extends StatelessWidget {
  const DonateTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context).translate('about_donate_title'),
      ),
      subtitle: Text(
        AppLocalizations.of(context).translate('about_donate_subtitle'),
      ),
      onTap: () {
        showDialog(context: context, builder: (context) => DonateDialog());
      },
    );
  }
}
