import 'package:flutter/material.dart';

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
            title: const Text('Ogni 15 minuti'),
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
            title: const Text('Ogni 30 minuti'),
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
            title: Text('Ogni 2 ore'),
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
            title: Text('Ogni 6 ore'),
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
