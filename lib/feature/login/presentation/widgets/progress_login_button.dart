import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';

enum LoadingState { initial, loading, loaded, error, success }

class ProgressLoginButton extends StatefulWidget {
  /// Username for login
  final String username;

  /// Password that
  final String password;

  final Function onSuccess;

  final Function onError;

  ProgressLoginButton({
    @required this.username,
    @required this.password,
    @required this.onSuccess,
    @required this.onError,
  });

  @override
  State<StatefulWidget> createState() => _ProgressLoginButtonState();
}

class _ProgressLoginButtonState extends State<ProgressLoginButton>
    with TickerProviderStateMixin {
  /// The state for the animation and login process
  LoadingState _loginState = LoadingState.initial;

  /// Width of the button
  double _width = 250;

  // Animation related stuff
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;

  static bool _isPressed = false, _animatingReveal = false;

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          _loginState = LoadingState.loading;
          _controller.forward();
        } else if (state is SignInSuccess) {
          setState(() {
            _loginState = LoadingState.success;
          });
          widget.onSuccess();
        } else if (state is SignInNetworkError) {
          setState(() {
            _loginState = LoadingState.error;
          });
          widget.onError();
        }
      },
      child: PhysicalModel(
        color: Colors.blue,
        elevation: calculateElevation(),
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          key: _globalKey,
          height: 50.0,
          width: _width,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.all(0.0),
            color: _getColorFromLoadingState(),
            child: buildButtonChild(),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SignIn(
                username: widget.username,
                password: widget.password,
              ));
            },
            onHighlightChanged: (isPressed) {
              setState(() {
                _isPressed = isPressed;
                if (_loginState == LoadingState.initial) {
                  animateButton();
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Color _getColorFromLoadingState() {
    if (_loginState == LoadingState.success) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
  }

  Widget buildButtonChild() {
    if (_loginState == LoadingState.initial) {
      return Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_loginState == LoadingState.loading) {
      return Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_loginState == LoadingState.success) {
      return Icon(Icons.check, color: Colors.white);
    } else {
      return Icon(Icons.clear, color: Colors.white);
    }
  }

  double calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 6.0 : 4.0;
    }
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _loginState = LoadingState.initial;
  }
}
