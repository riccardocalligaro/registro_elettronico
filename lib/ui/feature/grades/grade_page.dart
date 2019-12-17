import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 120,
        decoration: BoxDecoration(color: Colors.white),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  '8.0',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Italiano'),
                    Text('Media orale: 8.75'),
                    Text('Media scritto: 8.75'),
                    Text('Media paratico: 8.45')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
