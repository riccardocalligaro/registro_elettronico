import 'package:flutter/material.dart';

class GeneralObjectiveSettingsDialog extends StatefulWidget {
  int objective;

  GeneralObjectiveSettingsDialog({
    Key key,
    @required this.objective,
  }) : super(key: key);

  @override
  _GeneralObjectiveSettingsDialogState createState() =>
      _GeneralObjectiveSettingsDialogState();
}

class _GeneralObjectiveSettingsDialogState
    extends State<GeneralObjectiveSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Objective: ${widget.objective.toString()}"),
          Slider(
            value: widget.objective.toDouble(),
            max: 10,
            divisions: 7,
            min: 3,
            onChanged: (value) {
              setState(() {
                widget.objective = value.toInt();
              });
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, widget.objective);
            },
          )
        ],
      ),
    );
  }
}
