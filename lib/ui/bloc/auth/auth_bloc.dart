import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/parent_response.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginRepository loginRepository;
  ProfileRepository profileRepository;
  FlutterSecureStorage flutterSecureStorage;

  AuthBloc(
      this.loginRepository, this.profileRepository, this.flutterSecureStorage);

  Future<Profile> get profile => profileRepository.getDbProfile();
  @override
  AuthState get initialState => Init();

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
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getBool(PrefsConstants.VITAL_DATA_DOWNLOADED) ?? false) {
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
            FLog.info(text: loginReponse.toJson().toString());

            await flutterSecureStorage.write(
                key: event.username, value: event.password);
            _saveProfileInDb(loginReponse, event.password);
            FLog.info(text: 'Log in success');

            yield SignInSuccess(ProfileMapper()
                .mapLoginResponseProfileToProfileEntity(loginReponse));
          },
          (parentsLoginResponse) async* {
            FLog.info(text: 'Got parents response');
            final ParentsLoginResponse parentsLoginResponse =
                responseProfile.getOrElse(null);
            yield SignInParent(parentsLoginResponse);
          },
        );
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
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.clear();
      yield SignOutSuccess();
    }
  }

  _saveProfileInDb(LoginResponse returnedProfile, String userPassword) {
    FLog.info(text: 'Saving profile in database');
    final profileEntity =
        ProfileMapper().mapLoginResponseProfileToProfileEntity(returnedProfile);
    profileRepository.insertProfile(profile: profileEntity);
    flutterSecureStorage.write(key: profileEntity.ident, value: userPassword);
  }
}
