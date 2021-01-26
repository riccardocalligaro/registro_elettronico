import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/text_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/url_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/didactics_file.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/teacher_domain_model.dart';

abstract class DidacticsRepository {
  Stream<Resource<List<DidacticsTeacherDomainModel>>> watchTeachersMaterials();

  Future<Either<Failure, Success>> updateMaterials({@required bool ifNeeded});

  Stream<Resource<DidacticsFile>> downloadFile({
    @required ContentDomainModel contentDomainModel,
  });

  Future<Either<Failure, TextContentRemoteModel>> downloadText({
    @required ContentDomainModel contentDomainModel,
  });

  Future<Either<Failure, URLContentRemoteModel>> downloadURL({
    @required ContentDomainModel contentDomainModel,
  });
}
