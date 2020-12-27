import 'package:flutter/material.dart';

class DonateDialog extends StatefulWidget {
  DonateDialog({Key key}) : super(key: key);

  @override
  _DonateDialogState createState() => _DonateDialogState();
}

class _DonateDialogState extends State<DonateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Donation'),
            subtitle: Text('Grazie.'),
            trailing: Text('0.99€'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
