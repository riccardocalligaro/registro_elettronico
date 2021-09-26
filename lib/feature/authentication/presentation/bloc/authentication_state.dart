part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNeedsAccountSelection extends AuthenticationState {
  final ParentLoginResponseRemoteModel parentLoginResponseRemoteModel;

  AuthenticationNeedsAccountSelection({
    required this.parentLoginResponseRemoteModel,
  });
}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final Failure failure;

  AuthenticationFailure({
    required this.failure,
  });
}

// Sign out

class AuthenticationSignOutFailure extends AuthenticationState {}

class AuthenticationSignOutSuccess extends AuthenticationState {}
