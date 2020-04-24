import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug mode'),
      ),
      body: Column(
        children: <Widget>[
          // ListTile(
          //   title: Text('Update timetable widget'),
          //   trailing: RaisedButton(
          //     child: Text('Update'),
          //     onPressed: _updateWidgets,
          //   ),
          // )
        ],
      ),
    );
  }
}
