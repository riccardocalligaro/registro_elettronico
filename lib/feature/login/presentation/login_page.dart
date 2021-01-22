import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/gradient_red_button.dart';
import 'package:registro_elettronico/feature/home/home_page.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/auth_bloc.dart';

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
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(ResetAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is SignInSuccess) {
              /// If the sign in is successful then navigate to the home page
              AppNavigator.instance.navToHome(context);
            }

            if (state is SignInParent) {
              Scaffold.of(context)..removeCurrentSnackBar();
              await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(AppLocalizations.of(context)
                        .translate('select_a_profile')),
                    children: <Widget>[
                      Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.parentsLoginResponse.choices.length,
                          itemBuilder: (context, index) {
                            final user =
                                state.parentsLoginResponse.choices[index];
                            return ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.school),
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context).add(SignIn(
                                  username: user.ident,
                                  password: _passwordController.text,
                                ));
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              );
            }

            if (state is SignInNotConnected) {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    AppNavigator.instance.getNetworkErrorSnackBar(context));
            }

            if (state is SignInSuccess) {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ),
              );
            }

            /// Sets the valide data to true
            if (state is SignInNetworkError) {
              setState(() {
                //_valide = true;
                if (state.error.messageCode ==
                    RegistroConstants.USERNAME_PASSWORD_NOT_MATCHING) {
                  setState(() {
                    _invalid = true;

                    _erorrMessage = AppLocalizations.of(context)
                        .translate('username_password_doesent_match');
                  });
                } else {
                  setState(() {
                    _invalid = true;

                    _erorrMessage = state.error.message;
                  });
                }
              });
            }

            if (state is SignInError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "🤔 ${AppLocalizations.of(context).translate('unexcepted_error')}",
                ),
              ));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              //return Text(state.toString());
              if (state is SignInLoading || state is SignInSuccess) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _buildInitial();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitial() {
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
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: SvgPicture.asset(
        //     'assets/images/green_waves.svg',
        //   ),
        // ),
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
            Logger.info('Sign in button pressed');

            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            final username = _usernameController.text;
            final password = _passwordController.text;

            if (username != '' && password != '') {
              Logger.info(
                'Got valid input, proceeding to adding event to bloc',
              );
              BlocProvider.of<AuthBloc>(context).add(
                SignIn(
                  username: username,
                  password: password,
                ),
              );
            } else {
              Logger.info('Got empty input');
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
              onTap: () {
                // todo: navigate to repository
              },
              child: GestureDetector(
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
              ),
            )
          ],
        )
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
