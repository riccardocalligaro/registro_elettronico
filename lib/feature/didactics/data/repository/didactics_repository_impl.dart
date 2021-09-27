import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/didactics/data/datasource/didactics_local_datasource.dart';
import 'package:registro_elettronico/feature/didactics/data/datasource/didactics_remote_datasource.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/text_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/url_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/didactics_file.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/folder_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/teacher_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DidacticsRepositoryImpl implements DidacticsRepository {
  static const String lastUpdateKey = 'didacticsLastUpdate';

  final DidacticsLocalDatasource? didacticsLocalDatasource;
  final DidacticsRemoteDatasource? didacticsRemoteDatasource;
  final SharedPreferences? sharedPreferences;

  DidacticsRepositoryImpl({
    required this.didacticsLocalDatasource,
    required this.didacticsRemoteDatasource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, Success>> updateMaterials({
    required bool ifNeeded,
  }) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences!.getInt(lastUpdateKey)))) {
        final remoteTeachers =
            await didacticsRemoteDatasource!.getTeachersMaterials();

        List<int?> remoteContentIds = [];

        // iteriamo ogni professore
        for (final teacher in remoteTeachers) {
          for (final folder in teacher.folders!) {
            remoteContentIds.addAll(folder.contents!.map((e) => e.contentId));
          }
        }

        // get local content ids
        final localDownlaodedContents =
            await didacticsLocalDatasource!.getAllDownloadedFiles();

        List<DidacticsDownloadedFileLocalModel> filesToDelete = [];

        for (final localContent in localDownlaodedContents) {
          if (!remoteContentIds.contains(localContent.contentId)) {
            filesToDelete.add(localContent);
          }
        }

        // insert the new files
        List<TeacherLocalModel> localTeachers = [];
        List<FolderLocalModel> localFolders = [];
        List<ContentLocalModel> localContents = [];

        for (final teacher in remoteTeachers) {
          // aggiungiamo alla lista
          localTeachers.add(teacher.toLocalModel());

          List<FolderLocalModel> tempFolders = [];
          List<ContentLocalModel> tempContents = [];

          for (final folder in teacher.folders!) {
            tempFolders.add(folder.toLocalModel(teacherId: teacher.teacherId));
            for (final content in folder.contents!) {
              tempContents.add(content.toLocalModel(folderId: folder.folderId));
            }
          }

          // aggiungiamo alla lista
          localFolders.addAll(tempFolders);
          localContents.addAll(tempContents);
        }

        // Cancelliamo quelli locali
        await didacticsLocalDatasource!.deleteTeachers();
        await didacticsLocalDatasource!.deleteFolders();
        await didacticsLocalDatasource!.deleteContents();

        await didacticsLocalDatasource!.insertUpdateData(
          teachersList: localTeachers,
          foldersList: localFolders,
          contentsList: localContents,
        );

        // cancelliamo i file non presenti remotamente
        await didacticsLocalDatasource!.deleteDownloadedFiles(filesToDelete);

        await sharedPreferences!
            .setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      }
      return Right(SuccessWithoutUpdate());
    } catch (e, s) {
      return Left(
          handleError('[DidacticsRepository] Update materials error', e, s));
    }
  }

  @override
  Stream<Resource<List<DidacticsTeacherDomainModel?>>>
      watchTeachersMaterials() {
    return Rx.combineLatest4(
      didacticsLocalDatasource!.watchAllTeachers(),
      didacticsLocalDatasource!.watchAllFolders(),
      didacticsLocalDatasource!.watchAllContents(),
      didacticsLocalDatasource!.watchAllDownloadedFiles(),
      (
        List<TeacherLocalModel> localTeachers,
        List<FolderLocalModel> localFolders,
        List<ContentLocalModel> localContents,
        List<DidacticsDownloadedFileLocalModel> localDownloadedFiles,
      ) {
        final foldersMap = groupBy<FolderLocalModel, String?>(
          localFolders,
          (e) => e.teacherId,
        );

        final contentsMap = groupBy<ContentLocalModel, int?>(
          localContents,
          (e) => e.folderId,
        );

        final filesMap = groupBy<DidacticsDownloadedFileLocalModel, int?>(
          localDownloadedFiles,
          (e) => e.contentId,
        );

        final convertedTeachers = localTeachers.map((teacher) {
          final teacherMap = foldersMap[teacher.id];

          if (teacherMap == null) {
            return null;
          }

          return DidacticsTeacherDomainModel.fromLocalModel(
            localModel: teacher,
            folders: foldersMap[teacher.id]!.map((f) {
              final contentsFroMap = contentsMap[f.id];

              if (contentsFroMap == null) {
                return FolderDomainModel.fromLocalModel(
                  l: f,
                  contents: null,
                );
              }

              return FolderDomainModel.fromLocalModel(
                l: f,
                contents: contentsFroMap.map((c) {
                  final filesFromMap = filesMap[c.id];

                  if (filesFromMap == null) {
                    return ContentDomainModel.fromLocalModel(
                      l: c,
                      files: null,
                    );
                  }
                  return ContentDomainModel.fromLocalModel(
                    l: c,
                    files: filesFromMap
                        .map((file) => DidacticsFile.fromLocalModel(file))
                        .toList(),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }).toList();

        return Resource.success(data: convertedTeachers);
      },
    ).onErrorReturnWith(
      (e, s) {
        return Resource.failed(
          error:
              handleError('[DidacticsRepository] Watch materials error', e, s),
        );
      },
    );
  }

  @override
  Stream<Resource<DidacticsFile>> downloadFile({
    ContentDomainModel? contentDomainModel,
  }) async* {
    StreamController<Resource<DidacticsFile>> resourceStreamController =
        StreamController();

    try {
      resourceStreamController.add(Resource.loading(progress: 0));

      unawaited(_localPath.then((path) {
        didacticsRemoteDatasource!
            .downloadFile(
          content: contentDomainModel!,
          onProgress: (received, total) {
            resourceStreamController.add(
              Resource.loading(progress: received / total),
            );
          },
          path: path,
        )
            .then((response) async {
          final fileName = _fileName(
            path: path,
            headers: response.headers,
          );

          // insert into the database
          await didacticsLocalDatasource!.insertDownloadedFile(
            DidacticsDownloadedFileLocalModel(
              name: contentDomainModel.name,
              path: fileName,
              contentId: contentDomainModel.id,
            ),
          );

          // add to the resource contrailer
          resourceStreamController.add(
            Resource.success(
              data: DidacticsFile(
                contentId: contentDomainModel.id,
                name: contentDomainModel.name,
                file: File(fileName),
              ),
            ),
          );

          await resourceStreamController.close();
        });
      }).catchError((e, s) {
        resourceStreamController.add(Resource.failed(
          error: handleError('[DidacticsRepository] Download file error', e, s),
        ));

        return null;
      }));

      yield* resourceStreamController.stream;
    } catch (e, s) {
      yield Resource.failed(
          error:
              handleError('[DidacticsRepository] Watch materials error', e, s));
      await resourceStreamController.close();
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String _fileName({
    required String path,
    required Headers headers,
  }) {
    String filename = headers.value('content-disposition') ?? "";
    filename = filename.replaceAll('attachment; filename=', '');
    filename = filename.replaceAll(RegExp('\"'), '');
    filename = filename.trim();
    return '$path/$filename';
  }

  @override
  Future<Either<Failure, TextContentRemoteModel>> downloadText({
    required ContentDomainModel contentDomainModel,
  }) async {
    try {
      final text = await didacticsRemoteDatasource!.getTextContent(
        fileId: contentDomainModel.id,
      );

      return Right(text);
    } catch (e, s) {
      return Left(
          handleError('[DidacticsRepository] Download text error', e, s));
    }
  }

  @override
  Future<Either<Failure, URLContentRemoteModel>> downloadURL({
    required ContentDomainModel contentDomainModel,
  }) async {
    try {
      final url = await didacticsRemoteDatasource!.getURLContent(
        fileId: contentDomainModel.id,
      );

      return Right(url);
    } catch (e, s) {
      return Left(
          handleError('[DidacticsRepository] Download URL error', e, s));
    }
  }
}
