import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
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
    if (event is AutoSignIn) {
      yield AutoSignInLoading();
      final isUserLoggedIn = await profileRepository.isLoggedIn();
      if (isUserLoggedIn) {
        yield AutoSignInResult();
      } else {
        yield AutoSignInError();
      }
    }

    if (event is SignIn) {
      yield SignInLoading();
      try {
        final responseProfile = await loginRepository.signIn(
            username: event.username, password: event.password);
        await flutterSecureStorage.write(
            key: event.username, value: event.password);
        _saveProfileInDb(responseProfile, event.password);
//
        yield SignInSuccess(ProfileMapper()
            .mapLoginResponseProfileToProfileEntity(responseProfile));
      } on DioError catch (e) {
        yield SignInNetworkError(ServerException.fromJson(e.response.data));
      } catch (e) {
        yield SignInError(e.toString());
      }
    }

    if (event is SignOut) {
      await flutterSecureStorage.deleteAll();
      await profileRepository.deleteAllProfiles();
      // todo: delete all data
      yield SignOutSuccess();
    }
  }

  _saveProfileInDb(LoginResponse returnedProfile, String userPassword) {
    final profileEntity =
        ProfileMapper().mapLoginResponseProfileToProfileEntity(returnedProfile);
    profileRepository.insertProfile(profile: profileEntity);

    flutterSecureStorage.write(key: profileEntity.ident, value: userPassword);
  }
}
