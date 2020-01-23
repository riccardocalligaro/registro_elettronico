import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/document_table.dart';

part 'document_dao.g.dart';

@UseDao(tables: [
  Documents,
  SchoolReports,
  DownloadedDocuments,
])
class DocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsDaoMixin {
  AppDatabase db;
  DocumentsDao(this.db) : super(db);

  Future<List<SchoolReport>> getAllSchoolReports() =>
      select(schoolReports).get();

  Future<List<Document>> getAllDocuments() => select(documents).get();

  Future<List<DownloadedDocument>> getAllDownloadedDocuments() =>
      select(downloadedDocuments).get();

  Future<DownloadedDocument> getDownloadedDocument(String hash) {
    return (select(downloadedDocuments)..where((d) => d.hash.equals(hash)))
        .getSingle();
  }

  Future deleteAllDownloadedDocuments() => delete(downloadedDocuments).go();

  Future deleteDownloadedDocument(DownloadedDocument downloadedDocument) =>
      delete(downloadedDocuments).delete(downloadedDocument);

  Future insertDownloadedDocument(DownloadedDocument downloadedDocument) =>
      into(downloadedDocuments).insert(downloadedDocument, orReplace: true);

  Future deeteAllDocuments() => delete(documents).go();

  Future deeteAllSchoolReports() => delete(schoolReports).go();

  Future insertDocuments(List<Document> documentsList) =>
      into(documents).insertAll(documentsList, orReplace: true);

  Future insertSchoolReports(List<SchoolReport> schoolReportsList) =>
      into(schoolReports).insertAll(schoolReportsList, orReplace: true);

  Future<DownloadedDocument> getDownloadedDocumentFromHash(String hash) {
    return (select(downloadedDocuments)..where((g) => g.hash.equals(hash)))
        .getSingle();
  }
}
