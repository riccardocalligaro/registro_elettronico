import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/data/db/dao/document_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/document_mapper.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  ProfileRepository profileRepository;
  SpaggiariClient spaggiariClient;
  DocumentsDao documentsDao;

  DocumentsRepositoryImpl(
    this.spaggiariClient,
    this.profileRepository,
    this.documentsDao,
  );

  @override
  Future updateDocuments() async {
    final profile = await profileRepository.getDbProfile();
    await documentsDao.deeteAllDocuments();
    await documentsDao.deeteAllSchoolReports();

    final documents = await spaggiariClient.getDocuments(profile.studentId);

    List<Document> documentsList = [];
    List<SchoolReport> reportsList = [];

    documents.documents.forEach((document) {
      documentsList
          .add(DocumentMapper.convertApiDocumentToInsertable(document));
    });

    documents.schoolReports.forEach((report) {
      reportsList
          .add(DocumentMapper.convertApiSchoolReportToInsertable(report));
    });
    await documentsDao.insertDocuments(documentsList);
    await documentsDao.insertSchoolReports(reportsList);
  }

  @override
  Future<Tuple2<List<SchoolReport>, List<Document>>>
      getDocumentsAndSchoolReports() async {
    final List<SchoolReport> reports = await documentsDao.getAllSchoolReports();
    final List<Document> documents = await documentsDao.getAllDocuments();
    return Tuple2(reports, documents);
  }
}
