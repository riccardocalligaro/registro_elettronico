import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_local_model.dart';

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
      into(downloadedDocuments).insertOnConflictUpdate(downloadedDocument);

  Future deeteAllDocuments() => delete(documents).go();

  Future deeteAllSchoolReports() => delete(schoolReports).go();

  Future<void> insertDocuments(List<Document> documentsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(documents, documentsList);
    });
  }

  Future<void> insertSchoolReports(List<SchoolReport> schoolReportsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(schoolReports, schoolReportsList);
    });
  }

  Future<DownloadedDocument> getDownloadedDocumentFromHash(String hash) {
    return (select(downloadedDocuments)..where((g) => g.hash.equals(hash)))
        .getSingle();
  }
}
