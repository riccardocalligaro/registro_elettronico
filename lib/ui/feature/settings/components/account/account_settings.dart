import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';

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
            text: 'Account',
          ),
        ),
        ListTile(
          title: Text('Reset data'),
          subtitle: Text('Erase all the data and sync'),
          onTap: () {},
        )
      ],
    );
  }
}
