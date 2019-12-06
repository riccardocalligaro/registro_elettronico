import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as prefix0;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Lesson Card
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 0.0, 0.0),
        child: Container(
          width: 275.0,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.red,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 275,
                child: Row(
                  //TODO: Pills
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0, 0),
                      child: Container(
                        //TODO: Subject Related Icon
                        child: Icon(Icons.format_list_bulleted),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Container(
                        color: Colors.red,
                        child: Text("Matemathics",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            "Lorem  ipsum dolor sit a met txt only a test.",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
