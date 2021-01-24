part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class SignIn extends AuthenticationEvent {
  final LoginRequestDomainModel loginRequestDomainModel;

  SignIn({this.loginRequestDomainModel});
}

class SignOut extends AuthenticationEvent {}

class SignOutFromAllUsers extends AuthenticationEvent {}
