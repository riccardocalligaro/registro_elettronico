import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_event.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_state.dart';
import 'package:registro_elettronico/ui/feature/home/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const double LEFT_LOGIN_PADDING = 80.0;
  static const double TOP_FIELDS_PADDING = 32.0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _valide = false;
  String _errorMessage = "";

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
                    child: RaisedButton(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        _signIn(context);
                      },
                    )),
              ],
            ),
          ],
        ),
      )),
    );
  }

  SnackBar _buildLoadingSnackBar(String message) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
        ],
      ),
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
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            /// If the sign in is successful then navigate to the home page
            AppNavigator.instance.navToHome(context);
          }

          /// Sets the valide data to true
          if (state is SignInError) {
            setState(() {
              _valide = true;
              _errorMessage = state.message;
            });
          }

          if (state is SignInLoading) {
            AppNavigator.instance.showSnackBar(context, "Loading...");
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: TOP_FIELDS_PADDING),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      errorText: _valide ? "" : null,
                      contentPadding: EdgeInsetsGeometry.lerp(
                          const EdgeInsetsDirectional.only(end: 6.0),
                          EdgeInsets.symmetric(vertical: 5),
                          2.0)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      errorText: _valide ? "" : null,
                      contentPadding: EdgeInsetsGeometry.lerp(
                          const EdgeInsetsDirectional.only(end: 6.0),
                          EdgeInsets.symmetric(vertical: 5),
                          2.0)),
                ),
              ],
            ),
          ),
        ));
  }

  _signIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(SignIn(
        username: _usernameController.text,
        password: _passwordController.text));
  }
}
