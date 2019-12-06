import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';

part 'moor_database.g.dart';

@UseMoor(
  tables: [Profiles],
  daos: [ProfileDao]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;
}
