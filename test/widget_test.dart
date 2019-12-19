// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';

import 'package:registro_elettronico/main.dart';

void main() {
  test('login', () async {
    final appDb = AppDatabase();
    final profileDao = ProfileDao(appDb);

    await profileDao.insertProfile(null);
  });

  test('tabs layout q index', () {
    int index = 0;
  });
}
