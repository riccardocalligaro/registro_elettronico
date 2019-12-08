import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/login_request.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/ui/bloc/authentication/bloc.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final AuthenticationBloc authenticationBloc;
  final SpaggiariClient spaggiariClient;

  LoginBloc(
      {@required this.loginRepository,
      @required this.authenticationBloc,
      @required this.spaggiariClient});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final loginRequest = LoginRequest(
            ident: event.username, pass: event.password, uid: event.username);
        try {
          final returnedProfile = await spaggiariClient.loginUser(loginRequest);
          authenticationBloc.add(LoggedIn(
              profile: ProfileMapper()
                  .mapLoginResponseProfileToProfileEntity(returnedProfile)));
          print(returnedProfile.firstName);
        } catch (e) {
          if (e is DioError) {
            if (e.response.statusCode == 422) {
              yield LoginWrongCredentials();
            } else {
              yield LoginError(e.toString());
            }
          } else {
            yield LoginError(e.toString());
          }
          print(e);
        }
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
  }
}
