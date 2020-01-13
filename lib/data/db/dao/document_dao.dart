import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/document_table.dart';

part 'document_dao.g.dart';

@UseDao(tables: [
  Documents,
  SchoolReports,
])
class DocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsDaoMixin {
  AppDatabase db;
  DocumentsDao(this.db) : super(db);

  Future<List<SchoolReport>> getAllSchoolReports() =>
      select(schoolReports).get();

  Future<List<Document>> getAllDocuments() => select(documents).get();

  Future deeteAllDocuments() => delete(documents).go();

  Future deeteAllSchoolReports() => delete(schoolReports).go();

  Future insertDocuments(List<Document> documentsList) =>
      into(documents).insertAll(documentsList);

  Future insertSchoolReports(List<SchoolReport> schoolReportsList) =>
      into(schoolReports).insertAll(schoolReportsList);
}
