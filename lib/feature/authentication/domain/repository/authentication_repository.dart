import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/generic_login_response.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/credentials_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/login_request_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';

abstract class AuthenticationRepository {
  /// Returns true if the user is logged in
  Future<bool> isLoggedIn();

  Future<ProfileDomainModel> getProfile();

  /// Get the current student id, for making API Calls
  Future<String> getCurrentStudentId();

  Future<CredentialsDomainModel> getCredentials();

  Future<Either<Failure, List<ProfileDomainModel>>> getNonActiveAccounts();

  Future<Either<Failure, GenericLoginResponse>> loginUser({
    @required LoginRequestDomainModel loginRequestDomainModel,
    bool markCurrentAsInactive = false,
  });

  Future updateProfile({
    @required DefaultLoginResponseRemoteModel responseRemoteModel,
    @required ProfileDomainModel profileDomainModel,
  });

  Future<Either<Failure, Success>> logoutCurrentUser();

  Future<Either<Failure, Success>> switchToAccount({
    @required ProfileDomainModel profileDomainModel,
  });
}
