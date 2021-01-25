import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_mapper.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final AuthenticationRepository authenticationRepository;
  final LegacySpaggiariClient spaggiariClient;
  final DocumentsDao documentsDao;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  DocumentsRepositoryImpl(
    this.spaggiariClient,
    this.authenticationRepository,
    this.documentsDao,
    this.networkInfo,
    this.sharedPreferences,
  );

  @override
  Future updateDocuments() async {
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();
      final documents = await spaggiariClient.getDocuments(studentId);

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

      Logger.info(
        'Got ${documents.documents.length} documents from server, procceding to insert in database',
      );

      Logger.info(
        'Got ${documents.schoolReports.length} school reports from server, procceding to insert in database',
      );

      // Delete the documents
      await documentsDao.deeteAllDocuments();
      await documentsDao.deeteAllSchoolReports();

      await documentsDao.insertDocuments(documentsList);
      await documentsDao.insertSchoolReports(reportsList);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateScrutini,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
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
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();

      try {
        final available = await spaggiariClient.checkDocumentAvailability(
          studentId,
          documentHash,
        );

        return Right(available);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<Either<Failure, String>> readDocument(String documentHash) async {
    if (await networkInfo.isConnected) {
      try {
        final studentId = await authenticationRepository.getCurrentStudentId();
        Logger.info('Got profile');

        final document = await spaggiariClient.readDocument(
          studentId,
          documentHash,
        );
        String filename = document.value2;
        filename = filename.replaceAll('attachment; filename=', '');
        filename = filename.replaceAll(RegExp('\"'), '');
        filename = filename.trim();

        Logger.info('Filename -> $filename');
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
    } else {
      throw NotConntectedException();
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
    Logger.info('Checking downloaded with hash');
    final fileDb = await documentsDao.getDownloadedDocumentFromHash(hash);
    if (fileDb != null) {
      File file = File(fileDb.path);
      file.deleteSync();
      await documentsDao.deleteDownloadedDocument(fileDb);
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
