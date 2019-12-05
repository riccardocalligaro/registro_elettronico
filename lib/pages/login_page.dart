import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_elettronico/api/login/login_api_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Login'),
              onPressed: () async {
                final response = await Provider.of<LoginApiService>(context)
                    .postLogin({
                  'ident': 'S6102171X',
                  'pass': r'P2i75UnU$D',
                  'uid': 'S6102171X'
                });

                print(response.body);
              },
            )
          ],
        ),
      ),
    );
  }
}
