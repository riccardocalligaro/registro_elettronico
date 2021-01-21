import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/feature/professors/data/datasource/professors_local_datasource.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_remote_datasource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  static const String lastUpdateKey = 'subjectsLastUpdate';

  final SubjectsLocalDatasource subjectsLocalDatasource;
  final SubjectsRemoteDatasource subjectsRemoteDatasource;
  final SharedPreferences sharedPreferences;

  final ProfessorLocalDatasource professorLocalDatasource;

  SubjectsRepositoryImpl({
    @required this.subjectsLocalDatasource,
    @required this.subjectsRemoteDatasource,
    @required this.sharedPreferences,
    @required this.professorLocalDatasource,
  });

  @override
  Future<Either<Failure, Success>> updateSubjects({
    bool ifNeeded,
  }) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)))) {
        final localSubjects = await subjectsLocalDatasource.getAllSubjects();
        final localProfessors =
            await professorLocalDatasource.getAllProfessors();

        final remoteSubjects = await subjectsRemoteDatasource.getSubjects();

        final remoteIds = remoteSubjects.map((e) => e.id).toList();
        final remoteProfsIds = localProfessors.map((e) => e.id).toList();

        List<SubjectLocalModel> subjectsToDelete = [];
        List<ProfessorLocalModel> professorsToDelete = [];

        for (final localSubject in localSubjects) {
          if (!remoteIds.contains(localSubject.id)) {
            subjectsToDelete.add(localSubject);
          }
        }

        for (final localProfessor in localProfessors) {
          if (!remoteProfsIds.contains(localProfessor.id)) {
            professorsToDelete.add(localProfessor);
          }
        }

        // we also need to insert the teachers
        List<ProfessorLocalModel> professors = [];
        for (final subject in remoteSubjects) {
          professors.addAll(subject.professors
              .map((e) => e.toLocalModel(subject.id))
              .toList());
        }

        await subjectsLocalDatasource.insertSubjects(
          remoteSubjects
              .map(
                (e) => e.toLocalModel(),
              )
              .toList(),
        );

        await professorLocalDatasource.insertProfessors(professors);

        // delete the subjects that were removed from the remote source
        await subjectsLocalDatasource.deleteSubjects(subjectsToDelete);
        await professorLocalDatasource.deleteProfessors(subjectsToDelete);

        await sharedPreferences.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      } else {
        return Right(Success());
      }
    } catch (e, s) {
      return Left(handleStreamError(e, s));
    }
  }

  @override
  Stream<Resource<List<SubjectDomainModel>>> watchAllSubjects() {
    Rx.combineLatest2(
      professorLocalDatasource.watchAllProfessors(),
      subjectsLocalDatasource.watchAllSubjects(),
      (
        List<ProfessorLocalModel> professors,
        List<SubjectLocalModel> subjects,
      ) {
        final domainProfessors = professors
            .map((l) => ProfessorDomainModel.fromLocalModel(l))
            .toList();

        final subjectProfessors = groupBy<ProfessorDomainModel, int>(
          domainProfessors,
          (e) => e.subjectId,
        );

        final domainSubjects = subjects
            .map(
              (l) => SubjectDomainModel.fromLocalModel(
                  professors: subjectProfessors[l.id], l: l),
            )
            .toList();

        return Resource.success(data: domainSubjects);
      },
    )..onErrorReturnWith((e) {
        return Resource.failed(error: handleStreamError(e));
      });
  }
}
