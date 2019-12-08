import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/entity/profile.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Profile _profile;
  LoginRepository loginRepository;

  AuthBloc(this.loginRepository);

  @override
  AuthState get initialState => Init();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AutoSignIn) {
      yield AutoSignInLoading();
      final isUserLoggedIn = await loginRepository.isLoggedIn();
      if (isUserLoggedIn) {
        yield AutoSignInResult();
      } else {
        yield AutoSignInError();
      }
    }

    if (event is SignIn) {
      try {
        final returnedProfile = await loginRepository.signIn(
            username: event.username, password: event.password);
        _saveProfileInDb(returnedProfile);
        print(returnedProfile.firstName);
        yield SignInSuccess(ProfileMapper()
            .mapLoginResponseProfileToProfileEntity(returnedProfile));
      } catch (e) {
        if (e is DioError) {
          if (e.response.statusCode == 422) {
            yield SignInError(e.error.toString());
          } else {
            yield SignInError(e.error.toString());
          }
        } else {
          yield SignInError(e.toString());
        }
        print(e);
      }
    }

    if (event is SignOut) {
      await loginRepository.deleteAllProfiles();
      yield SignOutSuccess();
    }
  }

  _saveProfileInDb(LoginResponse returnedProfile) {
    loginRepository.insertProfile(
        profile: ProfileMapper()
            .mapLoginResponseProfileToProfileEntity(returnedProfile));
  }
}
