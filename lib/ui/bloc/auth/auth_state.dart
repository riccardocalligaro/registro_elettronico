import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/domain/entity/api_responses/parent_response.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Init extends AuthState {}

class SignInLoading extends AuthState {}

class SignInParent extends AuthState {
  final ParentsLoginResponse parentsLoginResponse;

  SignInParent(this.parentsLoginResponse);
}

class SignInSuccess extends AuthState {
  final Profile profile;

  SignInSuccess(this.profile);
}

class SignInError extends AuthState {
  final String message;

  SignInError(this.message);
}

class SignInNetworkError extends AuthState {
  final ServerException error;

  SignInNetworkError(this.error);
}

class SignInNotConnected extends AuthState {}

class SignOutSuccess extends AuthState {}

class AutoSignInLoading extends AuthState {}

class AutoSignInError extends AuthState {}

class AutoSignInNeedDownloadData extends AuthState {}

class AutoSignInResult extends AuthState {}
