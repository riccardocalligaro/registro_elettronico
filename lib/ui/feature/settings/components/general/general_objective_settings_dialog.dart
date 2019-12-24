import 'package:flutter/material.dart';

class GeneralObjectiveSettingsDialog extends StatefulWidget {
  final int objective;
  GeneralObjectiveSettingsDialog({
    Key key,
    this.objective,
  }) : super(key: key);

  @override
  _GeneralObjectiveSettingsDialogState createState() =>
      _GeneralObjectiveSettingsDialogState();
}

class _GeneralObjectiveSettingsDialogState
    extends State<GeneralObjectiveSettingsDialog> {
  int _objective;
  @override
  void initState() {
    _objective = widget.objective;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Objective: ${_objective.toString()}"),
          Slider(
            value: _objective.toDouble(),
            max: 10,
            divisions: 7,
            min: 3,
            onChanged: (value) {
              setState(() {
                _objective = value.toInt();
              });
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, _objective);
            },
          )
        ],
      ),
    );
  }
}
