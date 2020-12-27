import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/exception/server_exception.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_mapper.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/domain/repository/login_repository.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ProfileRepository profileRepository;
  final LoginRepository loginRepository;
  final FlutterSecureStorage flutterSecureStorage;

  AuthBloc({
    @required this.profileRepository,
    @required this.loginRepository,
    @required this.flutterSecureStorage,
  }) : super(AuthInitial());

  Future<Profile> get profile => profileRepository.getDbProfile();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    FLog.info(text: "$event added to Auth Bloc");

    if (event is AutoSignIn) {
      yield AutoSignInLoading();
      final isUserLoggedIn = await profileRepository.isLoggedIn();
      FLog.info(text: 'Auto sign in result: $isUserLoggedIn');
      if (isUserLoggedIn) {
        SharedPreferences prefs = sl();
        final vitalDataDownloaded =
            prefs.getBool(PrefsConstants.VITAL_DATA_DOWNLOADED) ?? false;
        if (!vitalDataDownloaded) {
          yield AutoSignInNeedDownloadData();
        } else {
          yield AutoSignInResult();
        }
      } else {
        yield AutoSignInError();
      }
    }

    if (event is SignIn) {
      yield SignInLoading();
      try {
        final responseProfile = await loginRepository.signIn(
            username: event.username, password: event.password);

        FLog.info(text: responseProfile.toString());
        // If it is classic login response

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
            _saveProfileInDb(loginReponse, event.password, email);
            FLog.info(text: 'Log in success');

            yield SignInSuccess(
                ProfileMapper.mapLoginResponseProfileToProfileEntity(
                    loginReponse));
          },
          (parentsLoginResponse) async* {
            FLog.info(text: 'Got parents response');
            final ParentsLoginResponse parentsLoginResponse =
                responseProfile.getOrElse(null);
            yield SignInParent(parentsLoginResponse);
          },
        );
      } on NotConntectedException {
        yield SignInNotConnected();
      } on DioError catch (e) {
        FLog.error(text: 'Error while logging in user: ${e.response.data}');
        yield SignInNetworkError(ServerException.fromJson(e.response.data));
      } catch (e, s) {
        FLog.error(
            text: 'Sign in other error ${e.toString()}, ${s.toString()};');
        yield SignInError(e.toString());
      }
    }

    if (event is SignOut) {
      await flutterSecureStorage.deleteAll();
      AppDatabase().resetDb();
      SharedPreferences sharedPreferences = sl();
      sharedPreferences.clear();
      yield SignOutSuccess();
    }
  }

  _saveProfileInDb(
      LoginResponse returnedProfile, String userPassword, String email) {
    FLog.info(text: 'Saving profile in database');
    final profileEntity = ProfileMapper.mapLoginResponseProfileToProfileEntity(
      returnedProfile,
    );
    profileRepository.insertProfile(profile: profileEntity);
    flutterSecureStorage.write(key: profileEntity.ident, value: userPassword);
  }
}
