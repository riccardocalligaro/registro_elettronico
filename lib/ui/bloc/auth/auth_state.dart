import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends AuthState {}

// sign states

class SignInLoading extends AuthState {}

class SignInSuccess extends AuthState {
  final String username;

  SignInSuccess(this.username) : assert(username != null);
}

class SignInError extends AuthState {
  final String error;

  SignInError(this.error);
}
