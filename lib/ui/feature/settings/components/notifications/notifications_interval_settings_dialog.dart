import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class NotificationsIntervalSettingsDialog extends StatefulWidget {
  int updateInterval;
  NotificationsIntervalSettingsDialog({
    Key key,
    @required this.updateInterval,
  }) : super(key: key);

  @override
  _NotificationsIntervalSettingsDialogState createState() =>
      _NotificationsIntervalSettingsDialogState();
}

class _NotificationsIntervalSettingsDialogState
    extends State<NotificationsIntervalSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
          child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text(
              AppLocalizations.of(context)
                  .translate('every_minutes')
                  .replaceAll('{m}', '15'),
            ),
            value: 15,
            groupValue: widget.updateInterval,
            onChanged: (value) {
              setState(() {
                widget.updateInterval = value;
              });
              Navigator.pop(context, value);
            },
          ),
          RadioListTile(
            title: Text(
              AppLocalizations.of(context)
                  .translate('every_minutes')
                  .replaceAll('{m}', '30'),
            ),
            value: 30,
            groupValue: widget.updateInterval,
            onChanged: (value) {
              setState(() {
                widget.updateInterval = value;
              });
              Navigator.pop(context, value);
            },
          ),
          RadioListTile(
            title: Text(
              AppLocalizations.of(context)
                  .translate('every_hours')
                  .replaceAll('{h}', '2'),
            ),
            value: 120,
            groupValue: widget.updateInterval,
            onChanged: (value) {
              setState(() {
                widget.updateInterval = value;
              });
              Navigator.pop(context, value);
            },
          ),
          RadioListTile(
            title: Text(
              AppLocalizations.of(context)
                  .translate('every_hours')
                  .replaceAll('{h}', '6'),
            ),
            value: 360,
            groupValue: widget.updateInterval,
            onChanged: (value) {
              setState(() {
                widget.updateInterval = value;
              });
              Navigator.pop(context, value);
            },
          )
        ],
      )),
    );
  }
}
