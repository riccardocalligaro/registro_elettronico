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
        switch (res.statusCode) {
          case 200:
            final profile = res.body;

            /**
             
            final profileDb = Profile(
                // TODO: remove same id, make nullable in the database table constructor
                id: 22,
                ident: profile.ident,
                userName: profile.ident,
                expire: DateTime.now(),
                token: profile.token,
                name: profile.firstName,
                classe: '4IA');
             */
            //authenticationBloc.dispatch(LoggedIn(profile: ));
            // authenticationBloc.
            authenticationBloc.add(LoggedIn(profile: profile));
            break;
          case 422:
            yield LoginError("Wrong user credentials");
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
