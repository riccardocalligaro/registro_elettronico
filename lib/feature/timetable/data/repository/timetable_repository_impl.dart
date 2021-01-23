import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/feature/lessons/data/datasource/lessons_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/timetable/data/datasource/timetable_local_datasource.dart';
import 'package:registro_elettronico/feature/timetable/data/model/genius_timetable_local_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/model/timetable_entry_presentation_model.dart';
import 'package:rxdart/rxdart.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableLocalDatasource timetableLocalDatasource;
  final LessonsLocalDatasource lessonsLocalDatasource;
  final SubjectsLocalDatasource subjectsLocalDatasource;

  TimetableRepositoryImpl({
    @required this.timetableLocalDatasource,
    @required this.lessonsLocalDatasource,
    @required this.subjectsLocalDatasource,
  });

  @override
  Future<Either<Failure, Success>> insertTimetableEntry({
    TimetableEntryDomainModel entry,
  }) async {
    try {
      await timetableLocalDatasource.insertTimetableEntry(entry.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> regenerateTimetable() async {
    try {
      List<GeniusTimetableLocalModel> geniusEntries =
          await lessonsLocalDatasource.getGeniusTimetable();

      List<TimetableEntryLocalModel> localEntries = [];

      for (final entry in geniusEntries) {
        localEntries.add(
          TimetableEntryLocalModel(
            start: entry.start,
            end: entry.end,
            dayOfWeek: int.parse(entry.dayOfWeek),
            id: null,
            subject: entry.subject,
            subjectName: entry.subjectName,
          ),
        );
      }

      await timetableLocalDatasource.deleteEntries();
      await timetableLocalDatasource.insertTimetableEntries(localEntries);

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateTimetableEntry({
    TimetableEntryDomainModel entry,
  }) async {
    try {
      await timetableLocalDatasource.updateTimetableEntry(entry.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Stream<Resource<List<TimetableEntryPresentationModel>>> watchEntries() {
    return Rx.combineLatest2(
      subjectsLocalDatasource.watchAllSubjects(),
      timetableLocalDatasource.watchAllEntries(),
      (
        List<SubjectLocalModel> localSubjects,
        List<TimetableEntryLocalModel> localEntries,
      ) {
        final Map<int, Color> colorsMap = Map.fromIterable(
          localSubjects,
          key: (e) => e.id,
          value: (e) => Color(
            int.tryParse(e.color ?? Colors.red.value) ?? Colors.red.value,
          ),
        );

        final domainModels = localEntries
            .map(
              (e) => TimetableEntryDomainModel.fromLocalModel(e),
            )
            .toList();

        final convertedModels = _convertTimetableEntries(
          domainModels: domainModels,
        );

        final presentationModels = convertedModels
            .map(
              (l) => TimetableEntryPresentationModel.fromDomainModel(
                l: l,
                color: colorsMap[l.subject],
              ),
            )
            .toList();

        return Resource.success(data: presentationModels);
      },
    ).onErrorReturnWith((e) => Resource.failed(error: handleStreamError(e)));
  }

  List<TimetableEntryDomainModel> _convertTimetableEntries({
    @required List<TimetableEntryDomainModel> domainModels,
  }) {
    final List<TimetableEntryDomainModel> timetable = [];

    final timetableMap = groupBy<TimetableEntryDomainModel, int>(
      domainModels,
      (e) => e.dayOfWeek,
    );

    timetableMap.forEach((key, value) {
      final List<TimetableEntryDomainModel> today = List.from(value);
      today.sort((a, b) => a.start.compareTo(b.start));

      // finchè ci sono dublicati
      for (var i = 0; i < today.length - 1; i++) {
        // se la materia dopo è uguale
        if (today[i].subject == today[i + 1].subject) {
          // controlla da cima a fondo e rimuovi un duplicato. Ripeti
          for (var j = 0; j < today.length - 1; j++) {
            if (today[j].subject != today[j + 1].subject) {
              continue;
            }

            var temp = today[j];
            temp.end = today[j + 1].end;
            today.removeAt(j);
            today[i] = temp;

            break;
          }
        }
      }

      // aggiungiamo alla lista
      timetable.addAll(today);
    });

    return timetable;
  }

  _subjectColor(int index) {
    final colors = [
      0xFFF44336,
      0xFFE91E63,
      0xFF9C27B0,
      0xFF7E57C2,
      0xFF1A237E,
      0xFF2196F3,
      0xFF0097A7,
      0xFF00796B,
      0xFF43A047,
      0xFFAFB42B,
      0xFFFB8C00,
      0xFFF4511E,
      0xFF6D4C41,
      0xFF607D8B,
      0xFFBDBDBD
    ];

    return;
  }
}
