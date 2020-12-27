import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  /// Checks if a user is conntected to the [network]
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
