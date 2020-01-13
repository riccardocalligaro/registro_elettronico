import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class DocumentsRepository {
  /// Gets both [school reports] and [documents]
  Future<Tuple2<List<SchoolReport>, List<Document>>>
      getDocumentsAndSchoolReports();

  Future updateDocuments();
}
