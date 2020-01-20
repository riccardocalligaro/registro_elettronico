import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/error/failures.dart';
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
    FLog.info(text: 'Got profile');

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

    FLog.info(
      text:
          'Got ${documents.documents.length} documents from server, procceding to insert in database',
    );

    FLog.info(
      text:
          'Got ${documents.schoolReports.length} school reports from server, procceding to insert in database',
    );
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

  @override
  Future<Either<Failure, bool>> checkDocument(String documentHash) async {
    final profile = await profileRepository.getDbProfile();
    FLog.info(text: 'Got profile');

    try {
      final available = await spaggiariClient.checkDocumentAvailability(
        profile.studentId,
        documentHash,
      );

      return Right(available);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> readDocument(String documentHash) async {
    try {
      final profile = await profileRepository.getDbProfile();
      FLog.info(text: 'Got profile');

      final document = await spaggiariClient.readDocument(
        profile.studentId,
        documentHash,
      );
      String filename = document.value2;
      filename = filename.replaceAll('attachment; filename=', '');
      filename = filename.replaceAll(RegExp('\"'), '');
      filename = filename.trim();
      FLog.info(text: 'Filename -> $filename');
      final path = await _localPath;
      String filePath = '$path/$filename';
      File file = File(filePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(document.value1);
      await raf.close();

      await documentsDao.insertDownloadedDocument(DownloadedDocument(
        path: filePath,
        filename: filename,
        hash: documentHash,
      ));

      return Right(filePath);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future deleteAllDownloadedDocuments() {
    return documentsDao.deleteAllDownloadedDocuments();
  }

  @override
  Future deleteDownloadedDocument(String hash) async {
    FLog.info(text: 'Checking downloaded');
    final fileDb = await documentsDao.getDownloadedDocumentFromHash(hash);
    if (fileDb != null) {
      File file = File(fileDb.path);
      file.deleteSync();
      documentsDao.deleteDownloadedDocument(fileDb);
    }
  }

  @override
  Future<List<DownloadedDocument>> getAllDownloadedDocuments() {
    return documentsDao.getAllDownloadedDocuments();
  }

  @override
  Future<DownloadedDocument> getDownloadedDocument(String hash) {
    return documentsDao.getDownloadedDocument(hash);
  }
}
