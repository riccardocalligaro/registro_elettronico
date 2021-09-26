import 'package:flutter/material.dart';

abstract class WebSpaggiariClient {
  Future<String> getPHPToken({
    required String? username,
    required String? password,
    bool? lastYear,
  });
}
