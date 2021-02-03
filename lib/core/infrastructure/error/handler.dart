import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

import 'failures_v2.dart';

Failure handleStreamError(
  dynamic e, [
  StackTrace s,
]) {
  if (e is Exception) {
  } else {
    e = Exception(e.toString());
  }

  return _handleError(e);
}

Failure handleError(
  dynamic e, [
  StackTrace s,
]) {
  // log the errror
  Logger.e(exception: e, stacktrace: s);
  return _handleError(e);
}

Failure _handleError(dynamic e) {
  if (e is Exception) {
  } else {
    e = Exception(e.toString());
  }

  if (e is DioError) {
    if (e is TimeoutException || e is SocketException || e.response == null) {
      return NetworkFailure(dioError: e);
    } else if (e.response.statusCode >= 500) {
      return ServerFailure(e);
    } else if (e.response.statusCode == 404) {
      return FunctionNotActivatedFailure();
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
