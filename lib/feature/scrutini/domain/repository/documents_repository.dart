import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';

abstract class DocumentsRepository {
  /// Gets both [school reports] and [documents]
  Future<Tuple2<List<SchoolReport>, List<Document>>>
      getDocumentsAndSchoolReports();

  Future updateDocuments();

  Future<Either<Failure, bool>> checkDocument(String documentHash);

  /// Returns the [path]
  Future<Either<Failure, String>> readDocument(String documentHash);

  Future<DownloadedDocument> getDownloadedDocument(String? hash);

  Future<List<DownloadedDocument>> getAllDownloadedDocuments();

  Future deleteAllDownloadedDocuments();

  Future deleteDownloadedDocument(String? hash);
}
