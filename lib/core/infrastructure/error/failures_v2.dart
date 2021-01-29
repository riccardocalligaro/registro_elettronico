import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

class Failure {
  const Failure({this.e});

  final Exception e;

  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('generic_failure');
  }
}

class DatabaseFailure extends Failure {
  @override
  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('database_failure');
  }
}

class NetworkFailure extends Failure {
  NetworkFailure({this.dioError});

  final DioError dioError;

  @override
  String localizedDescription(BuildContext context) {
    if (dioError is TimeoutException ||
        dioError is SocketException ||
        dioError.response == null) {
      return AppLocalizations.of(context).translate('network_failure');
    }

    return AppLocalizations.of(context).translate('network_failure_generic');
  }
}

class FunctionNotActivatedFailure extends Failure {
  FunctionNotActivatedFailure();

  @override
  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('function_not_activated');
  }
}

class ServerFailure extends NetworkFailure {
  ServerFailure(this.dioError) : super(dioError: dioError);

  @override
  final DioError dioError;

  @override
  String localizedDescription(BuildContext context) {
    if (dioError.response.statusCode == 404) {
      return AppLocalizations.of(context).translate('server_failure_404');
    }

    return AppLocalizations.of(context).translate('server_failure');
  }
}

class NotConnectedFailure extends NetworkFailure {
  @override
  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('not_connected_failure');
  }
}

class GenericFailureWithoutException extends GenericFailure {}

class GenericFailure extends Failure {
  GenericFailure({Exception e}) : super(e: e);

  @override
  String localizedDescription(BuildContext context) {
    return AppLocalizations.of(context).translate('generic_failure');
  }
}
