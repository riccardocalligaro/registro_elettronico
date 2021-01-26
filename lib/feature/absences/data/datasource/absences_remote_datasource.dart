import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/absences/domain/model/absences_response.dart';

class AbsencesRemoteDatasource {
  final Dio dio;

  AbsencesRemoteDatasource({
    @required this.dio,
  });

  Future<List<AbsenceRemoteModel>> getAbsences() async {
    final response = await dio.get(
      '/students/{studentId}/absences/details',
    );

    List<AbsenceRemoteModel> absences = List<AbsenceRemoteModel>.from(
      response.data['events'].map(
        (i) => AbsenceRemoteModel.fromJson(i),
      ),
    );

    return absences;
  }
}
