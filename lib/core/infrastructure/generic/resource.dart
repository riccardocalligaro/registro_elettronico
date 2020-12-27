import 'dart:async';

import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';

enum Status { loading, success, failed }

class Resource<T> {
  final Status status;
  final T data;
  final String message;
  final Exception failure;

  const Resource({
    this.data,
    @required this.status,
    this.message,
    this.failure,
  });

  static Resource<T> loading<T>({T data}) =>
      Resource<T>(data: data, status: Status.loading);

  static Resource<T> failed<T>({Exception error, T data}) => Resource<T>(
        failure: error,
        data: data,
        status: Status.failed,
      );

  static Resource<T> success<T>({T data}) =>
      Resource<T>(data: data, status: Status.success);

  static FutureOr<Resource<T>> asFuture<T>(FutureOr<T> Function() req) async {
    try {
      final res = await req();
      return success<T>(data: res);
    } on Exception catch (e) {
      return Future.error(failed(error: e, data: null));
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Resource<T> &&
        o.status == status &&
        o.data == data &&
        o.message == message &&
        o.failure == failure;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        data.hashCode ^
        message.hashCode ^
        failure.hashCode;
  }
}
