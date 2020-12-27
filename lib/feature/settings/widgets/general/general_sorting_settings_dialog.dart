import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

class GeneralSortingSettingsDialog extends StatefulWidget {
  final bool ascending;
  GeneralSortingSettingsDialog({Key key, @required this.ascending})
      : super(key: key);

  @override
  _GeneralSortingSettingsDialogState createState() =>
      _GeneralSortingSettingsDialogState();
}

class _GeneralSortingSettingsDialogState
    extends State<GeneralSortingSettingsDialog> {
  bool _ascending;

  @override
  void initState() {
    _ascending = widget.ascending;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          title:
              Text(AppLocalizations.of(context).translate('average_ascending')),
          value: true,
          groupValue: _ascending,
          onChanged: (value) {
            setState(() {
              _ascending = value;
            });
            Navigator.pop(context, value);
          },
        ),
        RadioListTile(
          title: Text(
              AppLocalizations.of(context).translate('average_descending')),
          value: false,
          groupValue: _ascending,
          onChanged: (value) {
            setState(() {
              _ascending = value;
            });
            Navigator.pop(context, value);
          },
        )
      ],
    );
  }
}
