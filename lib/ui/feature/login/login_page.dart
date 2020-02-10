import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_event.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_state.dart';
import 'package:registro_elettronico/ui/feature/widgets/gradient_red_button.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// This becomes `true` when a login error is thrown
  bool _invalid = false;

  /// Text that changes in case of a login [error]
  String _erorrMessage = "";

  // bool _valide = false;
  // String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              AppNavigator.instance.navToIntro(context);

              /// If the sign in is successful then navigate to the home page
              //AppNavigator.instance.navToHome(context);
            }

            if (state is SignInParent) {
              Scaffold.of(context)..removeCurrentSnackBar();
              showDialog(
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
              AppNavigator.instance.navToIntro(context);

              /// If the sign in is successful then navigate to the home page
              //AppNavigator.instance.navToHome(context);
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
              if (state is SignInLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _buildInitial();
              // return Padding(
              //   padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              //   child: Column(
              //     children: <Widget>[
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           // Welcome, login with Classeviva
              //           _buildWelcomeText(trans.translate('welcome')),
              //           _buildLoginMessageText(trans.translate('login_with')),
              //           _buildLoginForm(context),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 16.0),
              //             child: RaisedButton(
              //               child: Text(
              //                 trans.translate('log_in'),
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //               color: Theme.of(context).accentColor,
              //               onPressed: () {
              //                 _signIn(context);
              //               },
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // );
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
                SizedBox(
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
    // return Row(
    //   children: <Widget>[
    //     Text(
    //       'Login with',
    //       style: TextStyle(fontSize: 24),
    //     ),
    //     SizedBox(
    //       width: 7,
    //     ),
    //     Text(
    //       'Classeviva',
    //       style: TextStyle(
    //           fontSize: 24,
    //           fontWeight: FontWeight.bold,
    //           color: Theme.of(context).primaryColor),
    //     )
    //   ],
    // );
  }

  Widget _buildLoginInput() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)
                  .translate('login_username_input_field'),
              errorText: _invalid ? _erorrMessage : null),
        ),
        SizedBox(
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
        SizedBox(
          height: 30,
        ),
        GradientRedButton(
          center: Text(
            AppLocalizations.of(context).translate('log_in'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19),
          ),
          onTap: () {
            FLog.info(text: 'Sign in button pressed');

            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            final username = _usernameController.text;
            final password = _passwordController.text;

            if (username != '' && password != '') {
              FLog.info(
                text: 'Got valid input, proceeding to adding event to bloc',
              );

              BlocProvider.of<AuthBloc>(context).add(
                SignIn(
                  username: username,
                  password: password,
                ),
              );
            } else {
              FLog.info(text: 'Got empty input');
              setState(() {
                _invalid = true;
                _erorrMessage = AppLocalizations.of(context)
                    .translate('all_fields_message');
              });
            }
          },
        ),
        // ProgressLoginButton(() {
        //   // Navigator.pushReplacement(
        //   //   context,
        //   //   CircularRevealRoute(
        //   //     page: IntroSlideshowPage(),
        //   //     maxRadius: 800,
        //   //     centerAlignment: Alignment.center,
        //   //   ),
        //   // );
        // }),

        // ProgressLoginButton(
        //   username: _usernameController.text,
        //   password: _passwordController.text,
        //   onSuccess: () {
        //     Navigator.pushReplacement(
        //       context,
        //       CircularRevealRoute(
        //         page: IntroSlideshowPage(),
        //         maxRadius: 800,
        //         centerAlignment: Alignment.center,
        //       ),
        //     );
        //   },
        //   onError: () {},
        // ),
        SizedBox(
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
                    color: Theme.of(context).primaryColor,
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
          "$welcomeMessage,",
          style: Theme.of(context).textTheme.headline,
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
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        Container(
          child: Text('Classeviva',
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }

  // Widget _buildLoginForm(BuildContext context) {
  //   return BlocListener<AuthBloc, AuthState>(
  //     listener: (context, state) {
  //       if (state is SignInSuccess) {
  //         AppNavigator.instance.navToIntro(context);

  //         /// If the sign in is successful then navigate to the home page
  //         //AppNavigator.instance.navToHome(context);
  //       }

  //       /// Sets the valide data to true
  //       if (state is SignInNetworkError) {
  //         setState(() {
  //           _valide = true;
  //           if (state.error.messageCode ==
  //               RegistroConstants.USERNAME_PASSWORD_NOT_MATCHING) {
  //             _errorMessage = AppLocalizations.of(context)
  //                 .translate('username_password_doesent_match');
  //           } else {
  //             _errorMessage = state.error.message;
  //           }
  //         });
  //       }

  //       if (state is SignInError) {
  //         Scaffold.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //               "🤔 ${AppLocalizations.of(context).translate('unexcepted_error')}"),
  //         ));
  //       }

  //       if (state is SignInLoading) {
  //         Scaffold.of(context).showSnackBar(
  //           SnackBar(
  //             content:
  //                 Text(AppLocalizations.of(context).translate('loading_login')),
  //             duration: Duration(milliseconds: 2000),
  //           ),
  //         );
  //       }
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: TOP_FIELDS_PADDING),
  //       child: Container(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             TextFormField(
  //               controller: _usernameController,
  //               decoration: InputDecoration(
  //                 hintText: AppLocalizations.of(context)
  //                     .translate('username_form_login_placeholder'),
  //                 errorText: _valide ? _errorMessage : null,
  //                 contentPadding: EdgeInsetsGeometry.lerp(
  //                   const EdgeInsetsDirectional.only(end: 6.0),
  //                   EdgeInsets.symmetric(vertical: 5),
  //                   2.0,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20.0,
  //             ),
  //             TextFormField(
  //               controller: _passwordController,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 hintText: 'Password',
  //                 errorText: _valide ? _errorMessage : null,
  //                 contentPadding: EdgeInsetsGeometry.lerp(
  //                   const EdgeInsetsDirectional.only(end: 6.0),
  //                   EdgeInsets.symmetric(vertical: 5),
  //                   2.0,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _signIn(BuildContext context) {
  //   final username = _usernameController.text;
  //   final password = _passwordController.text;

  //   if (username != '' && password != '') {
  //     BlocProvider.of<AuthBloc>(context).add(SignIn(
  //         username: _usernameController.text,
  //         password: _passwordController.text));
  //   } else {
  //     setState(() {
  //       _valide = true;
  //       _errorMessage = 'Devi compilare tutti i campi';
  //     });
  //   }
  // }
}
