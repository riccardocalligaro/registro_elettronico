import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'failures.dart';

Failure handleError(String message, dynamic e, [StackTrace? s]) {
  // if we have a stacktrace
  if (s != null) {
    Fimber.e(message, ex: e, stacktrace: s);
  } else {
    // if we don't have a stack trace we return the current one
    Fimber.e(message, ex: e, stacktrace: StackTrace.current);
  }

  // errors that came from the http client
  if (e is DioError) {
    if (e is TimeoutException || e is SocketException || e.response == null) {
      return NetworkFailure(dioError: e);
    } else if (e.response!.statusCode! >= 500) {
      return ServerFailure(e);
    } else if (e.response!.statusCode == 404) {
      return FunctionNotActivatedFailure();
    } else {
      return NetworkFailure(dioError: e);
    }
  } else {
    // errors from the database
    if (e is SqliteException || e is MoorWrappedException) {
      return DatabaseFailure();
    }
    return GenericFailure(e: e);
  }
}
