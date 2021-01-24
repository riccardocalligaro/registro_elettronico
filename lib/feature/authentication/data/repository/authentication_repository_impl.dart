import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/core/data/remote/api/dio_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/generic_login_response.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/credentials_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/login_request_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/login_page.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  static const platform =
      MethodChannel('com.riccardocalligaro.registro_elettronico/multi-account');

  final AuthenticationRemoteDatasource authenticationRemoteDatasource;
  final ProfilesLocalDatasource profilesLocalDatasource;
  final FlutterSecureStorage flutterSecureStorage;
  final SharedPreferences sharedPreferences;

  AuthenticationRepositoryImpl({
    @required this.profilesLocalDatasource,
    @required this.flutterSecureStorage,
    @required this.sharedPreferences,
    @required this.authenticationRemoteDatasource,
  });

  @override
  Future<bool> isLoggedIn() async {
    final profile = await _getProfile();
    return profile != null;
  }

  @override
  Future<ProfileDomainModel> getProfile() async {
    final profile = await _getProfile();
    return profile;
  }

  @override
  Future<CredentialsDomainModel> getCredentials() async {
    final profile = await _getProfile();
    final password = await flutterSecureStorage.read(key: profile.ident);
    return CredentialsDomainModel(profile: profile, password: password);
  }

  @override
  Future<String> getCurrentStudentId() async {
    final profile = await _getProfile();
    return profile.studentId;
  }

  Future<ProfileDomainModel> _getProfile() async {
    final profileSingleton = _ProfileSingleton.instance;

    if (profileSingleton.profile != null) {
      return profileSingleton.profile;
    } else {
      final localProfiles = await profilesLocalDatasource.getLoggedInUser();

      if (localProfiles == null || localProfiles.isEmpty) {
        return null;
      }
      profileSingleton.profile =
          ProfileDomainModel.fromLocalModel(localProfiles.first);
    }

    return profileSingleton.profile;
  }

  @override
  Future<Either<Failure, GenericLoginResponse>> loginUser({
    LoginRequestDomainModel loginRequestDomainModel,
    bool markCurrentAsInactive = false,
  }) async {
    try {
      final users = await profilesLocalDatasource.getAllProfiles();
      final loggedInIds = users.map((e) => e.studentId);

      final response = await authenticationRemoteDatasource.loginUser(
        loginRequestDomainModel: loginRequestDomainModel,
      );

      return response.fold(
        (parentResponse) {
          return Right(GenericLoginResponse(
            response: Left(parentResponse),
          ));
        },
        (loginResponse) async {
          // here we are logged in
          // we need to insert the profile in the database
          final otherAccounts = await profilesLocalDatasource.getOtherUsers(
            loginResponse.ident,
          );

          String dbName;

          if (otherAccounts.isEmpty) {
            dbName = PrefsConstants.databaseNameBeforeMigration;
          } else {
            dbName = ProfileUtils.dbNameFromIdent(loginResponse.ident);
          }

          final localModel = loginResponse.toLocalModelFromLogin(
            currentlyLoggedIn: true,
            dbName: dbName,
          );

          if (loggedInIds.contains(localModel.studentId)) {
            return Left(AlreadyLoggedInFailure());
          }

          for (final user in otherAccounts) {
            if (user.currentlyLoggedIn) {
              await profilesLocalDatasource.updateProfile(
                user.copyWith(currentlyLoggedIn: false),
              );
            }
          }

          await profilesLocalDatasource.insertProfile(localModel);

          final domainModel = ProfileDomainModel.fromLocalModel(localModel);

          // we set the ingleton that we use for authentication
          _ProfileSingleton.instance.profile = domainModel;

          await flutterSecureStorage.write(
            key: domainModel.ident,
            value: loginRequestDomainModel.pass,
          );

          // se non ci sono altri account possiamo impostare il nome
          // del db di default e evitiamo di riavviare l'app
          if (otherAccounts.isEmpty) {
            await sharedPreferences.setString(
              PrefsConstants.databaseName,
              PrefsConstants.databaseNameBeforeMigration,
            );
          } else {
            // se ci sono altri account allora significa che attualmente stiamo
            // su un altro db
            // dobbiamo impostare il nuovo db nelle shared preferences e riavviare l'app
            await sharedPreferences.setString(
              PrefsConstants.databaseName,
              dbName,
            );

            await _restartApp();
          }

          return Right(GenericLoginResponse(
            response: Right(loginResponse),
          ));
        },
      );
    } on DioError catch (e) {
      return Left(LoginFailure(dioError: e));
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future updateProfile({
    DefaultLoginResponseRemoteModel responseRemoteModel,
    ProfileDomainModel profileDomainModel,
  }) async {
    final localModel = responseRemoteModel.toLocalModel(profileDomainModel);
    await profilesLocalDatasource.updateProfile(localModel);
    final domainModel = ProfileDomainModel.fromLocalModel(localModel);
    // we update the singleton
    _ProfileSingleton.instance.profile = domainModel;
  }

  @override
  Future<Either<Failure, Success>> logoutCurrentUser() async {
    try {
      // delete the user from the database
      final profile = await _getProfile();
      await profilesLocalDatasource.deleteProfile(profile.toLocalModel());

      final otherAccounts = await profilesLocalDatasource.getInactiveUsers();

      if (otherAccounts.isNotEmpty) {
        // se ci sono presenti altri account nel database

        final newAccount = otherAccounts.first;

        await profilesLocalDatasource.updateProfile(
          newAccount.copyWith(currentlyLoggedIn: true),
        );

        final account = ProfileDomainModel.fromLocalModel(otherAccounts.first);
        _ProfileSingleton.instance.profile = account;

        // set the db name in the shared preferences
        await sharedPreferences.setString(
          PrefsConstants.databaseName,
          newAccount.dbName,
        );

        // chiama il metodo per riavviare l'app
        await _restartApp();
      } else {
        // se non sono presenti altri account nel database
        await sharedPreferences.setString(
          PrefsConstants.databaseName,
          PrefsConstants.databaseNameBeforeMigration,
        );

        _ProfileSingleton.instance.profile = null;

        await navigator.currentState.push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, List<ProfileDomainModel>>>
      getNonActiveAccounts() async {
    try {
      final otherAccounts = await profilesLocalDatasource.getInactiveUsers();

      final domainAccounts = otherAccounts
          .map((e) => ProfileDomainModel.fromLocalModel(e))
          .toList();

      return Right(domainAccounts);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  Future<void> _restartApp() {
    // if (!kDebugMode) {
    return platform.invokeMethod('restartApp');
    // }
  }

  @override
  Future<Either<Failure, Success>> switchToAccount({
    ProfileDomainModel profileDomainModel,
  }) async {
    try {
      // set the other profiles to not logged in
      // just for safety we do this for all of them
      final otherAccounts = await profilesLocalDatasource.getOtherUsers(
        profileDomainModel.ident,
      );

      for (final user in otherAccounts) {
        if (user.currentlyLoggedIn) {
          await profilesLocalDatasource
              .updateProfile(user.copyWith(currentlyLoggedIn: false));
        }
      }

      final localModel = profileDomainModel.toLocalModel();
      // we set the current one to active
      await profilesLocalDatasource
          .updateProfile(localModel.copyWith(currentlyLoggedIn: true));

      // we have to set also the shared preferences
      if (profileDomainModel.dbName.isNotEmpty) {
        await sharedPreferences.setString(
          PrefsConstants.databaseName,
          profileDomainModel.dbName,
        );
      } else {
        return Left(FatalSwitchFailure());
      }

      _ProfileSingleton.instance.profile =
          ProfileDomainModel.fromLocalModel(localModel);

      // now that we have set all the variables we can restart the app
      await _restartApp();

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}

class _ProfileSingleton {
  static final _ProfileSingleton _singleton = _ProfileSingleton._internal();
  _ProfileSingleton._internal();
  static _ProfileSingleton get instance => _singleton;

  ProfileDomainModel profile;
}

class AlreadyLoggedInFailure extends Failure {
  @override
  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('already_logged_in');
  }
}

class FatalSwitchFailure extends Failure {}

class LoginFailure extends Failure {
  DioError dioError;

  LoginFailure({@required this.dioError});

  @override
  String localizedDescription(BuildContext context) {
    if (dioError.response != null) {
      if (dioError.response.statusCode == 422) {
        return AppLocalizations.of(context)
            .translate('username_password_doesent_match');
      } else if (dioError.response.statusCode >= 500) {
        return AppLocalizations.of(context)
            .translate('server_login')
            .replaceAll('{code}', dioError.response.statusCode.toString());
      }
    }

    return super.localizedDescription(context);
  }
}
