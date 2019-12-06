import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const double LEFT_LOGIN_PADDING = 80.0;
  static const double TOP_FIELDS_PADDING = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(LEFT_LOGIN_PADDING, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Welcome, login with Classeviva
                _buildWelcomeText("Welcome, "),
                _buildLoginMessageText("Classeviva"),
                _buildLoginForm(),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: _buildLoginButton('Log in')),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is SignInInitial) {
                      return Text('Not logged in!');
                    }
                    if (state is SignInLoading) {
                      return CircularProgressIndicator();
                    }
                    if (state is SignInSuccess) {
                      return Text(state.username);
                    }
                    if (state is SignInError) {
                      return Text(state.error);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  Container _buildWelcomeText(String welcomeMessage) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "Welcome,",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Row _buildLoginMessageText(String registerName) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            "Login with ",
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        Container(
          child: Text("Classeviva",
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: EdgeInsets.only(top: TOP_FIELDS_PADDING),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Username',
                  contentPadding: EdgeInsetsGeometry.lerp(
                      const EdgeInsetsDirectional.only(end: 6.0),
                      EdgeInsets.symmetric(vertical: 5),
                      2.0)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsetsGeometry.lerp(
                      const EdgeInsetsDirectional.only(end: 6.0),
                      EdgeInsets.symmetric(vertical: 5),
                      2.0)),
            ),
          ],
        ),
      ),
    );
  }

  RaisedButton _buildLoginButton(String buttonText) {
    return RaisedButton(
      child: Text(
        'Log in',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      color: Colors.blue,
      onPressed: () {
        BlocProvider.of<AuthBloc>(context).add(SignIn("xx", "xx"));
      },
    );
  }
}
