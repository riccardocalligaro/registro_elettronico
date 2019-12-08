import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/home_page.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _alreadyInit = false;

  final String _myUsername = "S6102171X";
  final String _myPassword = "EB9O57aW5N0P6Fq6";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_alreadyInit) {
      _alreadyInit = true;
      _autoSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Column(
          children: <Widget>[
            BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  print(state);
                  if (state is AutoSignInResult) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                  if (state is AutoSignInError) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                child: Container()),
            RaisedButton(
              child: Text('agg'),
              onPressed: () {
                _autoSignIn(context);
              },
            )
          ],
        ));
  }

  _signIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context)
        .add(SignIn(username: _myUsername, password: _myPassword));
  }

  void _autoSignIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AutoSignIn());
  }
}
