import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginRepository _loginRepository;

  AuthenticationBloc(this._loginRepository) : assert(_loginRepository != null);

  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final isUserLoggedIn = await _loginRepository.isLoggedIn();
      print("isUserLoggedIn" + isUserLoggedIn.toString());
      if (isUserLoggedIn) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      print("insert profile!");
      await _loginRepository.insertProfile(profile: event.profile);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      //_loginRepository.deleteAllProfiles();
      yield AuthenticationUnauthenticated();
    }
  }
}
