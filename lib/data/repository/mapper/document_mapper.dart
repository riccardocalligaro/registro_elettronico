import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/api_responses/documents_response.dart';

class DocumentMapper {
  static Document convertApiDocumentToInsertable(ApiDocument document) {
    return Document(
      description: document.desc ?? '',
      hash: document.hash ?? '',
    );
  }

  static SchoolReport convertApiSchoolReportToInsertable(
      ApiSchoolReport schoolReport) {
    return SchoolReport(
      description: schoolReport.desc ?? '',
      viewLink: schoolReport.viewLink ?? '',
      confirmLink: schoolReport.confirmLink ?? '',
    );
  }
}
