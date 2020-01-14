import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/error/failures.dart';

abstract class WebSpaggiariClient {
  Future<String> getPHPToken({
    @required String username,
    @required String password,
  });
}
