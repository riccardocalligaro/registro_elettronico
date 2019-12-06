import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];
}
