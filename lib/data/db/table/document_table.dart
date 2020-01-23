import 'package:moor_flutter/moor_flutter.dart';

class Documents extends Table {
  TextColumn get hash => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {hash};
}

class SchoolReports extends Table {
  TextColumn get description => text()();
  TextColumn get confirmLink => text()();
  TextColumn get viewLink => text()();

  @override
  Set<Column> get primaryKey => {viewLink};
}

class DownloadedDocuments extends Table {
  TextColumn get hash => text()();
  TextColumn get path => text()();
  TextColumn get filename => text()();

  @override
  Set<Column> get primaryKey => {hash};
}
