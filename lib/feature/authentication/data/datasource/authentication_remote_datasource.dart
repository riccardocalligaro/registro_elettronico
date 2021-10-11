// @POST("/auth/login")
// Future<Either<LoginResponse, ParentsLoginResponse>> loginUser(
//     @Body() LoginRequest loginRequest);

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/login_request_domain_model.dart';

class AuthenticationRemoteDatasource {
  final Dio dio;

  AuthenticationRemoteDatasource({
    required this.dio,
  });

  Future<
      Either<ParentLoginResponseRemoteModel,
          DefaultLoginResponseRemoteModel>> loginUser({
    required LoginRequestDomainModel loginRequestDomainModel,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: loginRequestDomainModel.toJson(),
    );

    if (response.statusCode == 200 &&
        response.data.containsKey('requestedAction')) {
      return Left(ParentLoginResponseRemoteModel.fromJson(response.data));
    }

    return Right(DefaultLoginResponseRemoteModel.fromJson(response.data));
  }
}
