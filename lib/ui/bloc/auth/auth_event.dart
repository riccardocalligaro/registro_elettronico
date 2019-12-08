import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends AuthEvent {
  final String username;
  final String password;

  SignIn({this.username, this.password});
}

class SignOut extends AuthEvent {}

class AutoSignIn extends AuthEvent {}
