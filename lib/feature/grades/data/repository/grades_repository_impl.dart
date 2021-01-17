import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_remote_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class GradesRepositoryImpl extends GradesRepository {
  static const String lastUpdateKey = 'gradesLastUpdate';

  final GradesRemoteDatasource gradesRemoteDatasource;
  final GradesLocalDatasource gradesLocalDatasource;
  final PeriodDao periodDao;

  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  GradesRepositoryImpl({
    @required this.gradesRemoteDatasource,
    @required this.gradesLocalDatasource,
    @required this.networkInfo,
    @required this.sharedPreferences,
    @required this.periodDao,
  });

  @override
  Future<Either<Failure, GradeDomainModel>> getGrade(String id) async {}

  @override
  Future<Either<Failure, List<GradeDomainModel>>> getGrades() async {
    try {
      final grades = await gradesLocalDatasource.getGrades();
      return Right(grades
          .map(
            (e) => GradeDomainModel.fromLocalModel(e),
          )
          .toList());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> updateGrades({bool ifNeeded}) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)))) {
        final remoteGrades = await gradesRemoteDatasource.getGrades();

        final localGrades = await gradesLocalDatasource.getGrades();

        final gradesMap = Map<int, GradeLocalModel>.fromIterable(localGrades,
            key: (v) => v.evtId, value: (v) => v);

        // get the ids
        final remoteIds = remoteGrades.map((e) => e.evtId).toList();

        List<GradeLocalModel> gradesToDelete = [];

        for (final localGrade in localGrades) {
          if (!remoteIds.contains(localGrade.evtId)) {
            gradesToDelete.add(localGrade);
          }
        }

        await gradesLocalDatasource.insertGrades(
          remoteGrades
              .map((e) => GradeLocalModelConverter.fromRemoteModel(
                    e,
                    gradesMap[e.evtId],
                  ))
              .toList(),
        );

        // delete the grades that were removed from the remote source
        await gradesLocalDatasource.deleteGrades(gradesToDelete);

        await sharedPreferences.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      }
      return Right(SuccessWithoutUpdate());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Stream<Resource<List<GradeDomainModel>>> watchAllGrades() async* {
    yield* gradesLocalDatasource.watchGrades().map((localModels) {
      return Resource.success(
          data: localModels
              .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
              .toList());
    }).onErrorReturnWith(
      (e) {
        Logger.e(exception: e);
        return Resource.failed(error: e);
      },
    );
  }

  @override
  Stream<Resource<List<GradeSectionDomainModel>>>
      watchAllGradesSections() async* {
    final periods = await periodDao.getAllPeriods();

    yield* gradesLocalDatasource.watchGrades().map((localGrades) {
      // dobbiamo convertire i modelli locali dividendoli in più periods
      List<GradeSectionDomainModel> sections = [];

      // sort them
      // localGrades.sort((b, a) => a.eventDate.compareTo(b.eventDate));

      sections.add(GradeSectionDomainModel(
        period: null,
        grades: localGrades
            .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
            .toList(),
      ));

      for (final period in periods) {
        final gradesForThisPeriod = localGrades
            .where((g) => g.periodPos == period.position)
            .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
            .toList();

        sections.add(GradeSectionDomainModel(
          period: period,
          grades: gradesForThisPeriod,
        ));
      }

      return Resource.success(data: sections);
    }).onErrorReturnWith(
      (e) {
        Logger.e(exception: e);
        return Resource.failed(error: e);
      },
    );
  }
}
