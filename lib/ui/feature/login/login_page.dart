import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 197, 0, 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("Welcome,"),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text("Login with "),
                    ),
                    Container(
                      child: Text("Classeviva",
                          style: TextStyle(color: Colors.red[300])),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username',
                        contentPadding: EdgeInsetsGeometry.lerp(const EdgeInsetsDirectional.only(end : 0.0),null, 10.0)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
