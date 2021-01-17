import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

import 'failures_v2.dart';

Failure handleError(
  Exception e, [
  StackTrace s,
]) {
  // log the errror
  Logger.info(e.toString());

  if (e is DioError) {
    if (e is TimeoutException || e is SocketException || e.response == null) {
      return NetworkFailure(dioError: e);
    } else if (e.response.statusCode >= 500) {
      return ServerFailure(e);
    } else {
      return NetworkFailure(dioError: e);
    }
  } else {
    if (e is SqliteException || e is MoorWrappedException) {
      return DatabaseFailure();
    }
    return GenericFailure(e: e);
  }
}
