part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}


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
