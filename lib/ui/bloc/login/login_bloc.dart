import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/ui/bloc/authentication/bloc.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc(
      {@required this.loginRepository, @required this.authenticationBloc});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final res = await loginRepository.signIn(
            username: event.username, password: event.password);
        print("Usernaem sumbitted: " + event.username);
        print("Password sumbitted: " + event.password);

        print(res.statusCode);
        print(res.bodyString);
        switch (res.statusCode) {
          case 200:
            final profile = res.body;
            authenticationBloc.add(LoggedIn(profile: profile));
            break;
          case 422:
            print('wrong user credentials');
            yield LoginWrongCredentials();
            break;
          default:
            yield LoginError(
                "A strange error has accoured! Status code ${res.statusCode}");
            break;
        }
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
  }
}
