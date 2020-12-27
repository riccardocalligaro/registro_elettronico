import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_remote_model.dart';

class DocumentMapper {
  static Document convertApiDocumentToInsertable(DocumentRemoteModel document) {
    return Document(
      description: document.desc ?? '',
      hash: document.hash ?? '',
    );
  }

  static SchoolReport convertApiSchoolReportToInsertable(
      SchoolReportRemoteModel schoolReport) {
    return SchoolReport(
      description: schoolReport.desc ?? '',
      viewLink: schoolReport.viewLink ?? '',
      confirmLink: schoolReport.confirmLink ?? '',
    );
  }
}
