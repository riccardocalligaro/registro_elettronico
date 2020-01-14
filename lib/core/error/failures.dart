import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure({this.properties = const <dynamic>[]});
  @override
  List<Object> get props => [properties];
}

// General failures
class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure({this.statusCode});
  @override
  List<Object> get props => [statusCode];
}

class DatabaseFailure extends Failure {}
