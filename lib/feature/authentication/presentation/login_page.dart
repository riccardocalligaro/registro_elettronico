import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/gradient_red_button.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/login_request_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// This becomes `true` when a login error is thrown
  bool _invalid = false;

  /// Text that changes in case of a login [error]
  String _erorrMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            setState(() {
              _invalid = true;
              _erorrMessage = state.failure.localizedDescription(context);
            });
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return _buildLoginForm();
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 90,
                ),
                _buildHeaderText(),
                _buildLoginInput(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginInput() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)
                  .translate('login_username_input_field'),
              errorText: _invalid ? _erorrMessage : null),
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            errorText: _invalid ? _erorrMessage : null,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GradientRedButton(
          center: Text(
            AppLocalizations.of(context).translate('log_in'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19),
          ),
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            final username = _usernameController.text;
            final password = _passwordController.text;

            if (username != '' && password != '') {
              BlocProvider.of<AuthenticationBloc>(context).add(
                SignIn(
                  loginRequestDomainModel: LoginRequestDomainModel(
                    ident: username,
                    pass: password,
                    uid: username,
                  ),
                ),
              );
            } else {
              setState(() {
                _invalid = true;
                _erorrMessage = AppLocalizations.of(context)
                    .translate('all_fields_message');
              });
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${AppLocalizations.of(context).translate('secure')}. ',
              style: TextStyle(color: Colors.grey),
            ),
            GestureDetector(
              onTap: () async {
                final url = RegistroConstants.WEBSITE;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                'Open source.',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  /// Builds the login with classeviva [title]
  Widget _buildHeaderText() {
    return Column(
      children: <Widget>[
        _buildWelcomeText(AppLocalizations.of(context).translate('welcome')),
        _buildLoginMessageText(
            AppLocalizations.of(context).translate('login_with')),
      ],
    );
  }

  Container _buildWelcomeText(String welcomeMessage) {
    return Container(
      //padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "${DateUtils.localizedTimeMessage(context)}, ",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  Row _buildLoginMessageText(String loginMessage) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            '$loginMessage ',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Container(
          child: Text('Classeviva',
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }
}
