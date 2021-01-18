import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart'
    hide Profile;
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/exception/server_exception.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/domain/repository/login_repository.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_entity.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_mapper.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ProfileRepository profileRepository;
  final LoginRepository loginRepository;
  final FlutterSecureStorage flutterSecureStorage;
  final SharedPreferences sharedPreferences;

  AuthBloc({
    @required this.profileRepository,
    @required this.loginRepository,
    @required this.flutterSecureStorage,
    @required this.sharedPreferences,
  }) : super(AuthInitial());

  Profile get profile => profileRepository.getProfile();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    Logger.info("$event added to Auth Bloc");
    if (event is ResetAuth) {
      yield AuthInitial();
    } else if (event is AutoSignIn) {
      yield AutoSignInLoading();
      final isUserLoggedIn = await profileRepository.isLoggedIn();

      Logger.info('Auto sign in result: $isUserLoggedIn');

      if (isUserLoggedIn) {
        yield AutoSignInResult();
      } else {
        yield AutoSignInError();
      }
    } else if (event is SignIn) {
      yield SignInLoading();
      try {
        final responseProfile = await loginRepository.signIn(
            username: event.username, password: event.password);

        Logger.info(responseProfile.toString());

        yield* responseProfile.fold(
          (loginReponse) async* {
            await flutterSecureStorage.write(
              key: loginReponse.ident,
              value: event.password,
            );

            String regEx =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            String email = '';
            if (event.username.contains(RegExp(regEx))) {
              email = event.username;
            }

            await _saveProfile(loginReponse, event.password, email);

            Logger.info('Log in success');

            yield SignInSuccess(
                ProfileMapper.mapLoginResponseProfileToProfileEntity(
                    loginReponse));
          },
          (parentsLoginResponse) async* {
            Logger.info('Got parents response');
            final ParentsLoginResponse parentsLoginResponse =
                responseProfile.getOrElse(null);
            yield SignInParent(parentsLoginResponse);
          },
        );
      } on NotConntectedException {
        yield SignInNotConnected();
      } on DioError catch (e) {
        Logger.e(text: 'Error while logging in user: ${e.response.data}');
        yield SignInNetworkError(ServerException.fromJson(e.response.data));
      } catch (e, s) {
        Logger.e(text: 'Sign in other error ${e.toString()}, ${s.toString()};');
        yield SignInError(e.toString());
      }
    }

    if (event is SignOut) {
      await flutterSecureStorage.deleteAll();
      await sharedPreferences.clear();
      final AppDatabase appDatabase = sl();
      await appDatabase.resetDb();
      yield SignOutSuccess();
    }
  }

  Future<void> _saveProfile(
    LoginResponse returnedProfile,
    String userPassword,
    String email,
  ) async {
    Logger.info('Saving profile in database');

    final profileEntity = ProfileMapper.mapLoginResponseProfileToProfileEntity(
      returnedProfile,
    );

    Logger.info('Profile $profileEntity');

    // save it to shared preferences
    await sharedPreferences.setString(
        PrefsConstants.profile, profileEntity.toJson());

    await flutterSecureStorage.write(
        key: profileEntity.ident, value: userPassword);
  }
}
