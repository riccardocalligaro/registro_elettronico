import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_remote_model.dart';

class PeriodsRemoteDatasource {
  final Dio dio;

  PeriodsRemoteDatasource({
    @required this.dio,
  });

  Future<List<PeriodRemoteModel>> getPeriods() async {
    final response = await dio.get('/students/{studentId}/periods');

    List<PeriodRemoteModel> periods = List<PeriodRemoteModel>.from(
      response.data['periods'].map(
        (i) => PeriodRemoteModel.fromJson(i),
      ),
    );

    return periods;
  }
}
