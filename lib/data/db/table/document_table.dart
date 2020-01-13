import 'package:moor_flutter/moor_flutter.dart';

class Documents extends Table {
  TextColumn get hash => text()();
  TextColumn get description => text()();
}

class SchoolReports extends Table {
  TextColumn get description => text()();
  TextColumn get confirmLink => text()();
  TextColumn get viewLink => text()();
}
