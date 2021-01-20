// @GET("/students/{studentId}/agenda/all/{start}/{end}")
// Future<AgendaResponse> getAgenda(@Path() String studentId,
//     @Path("start") String start, @Path("end") String end);

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_remote_model.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';

class AgendaRemoteDatasource {
  final Dio dio;
  final ProfileRepository profileRepository;

  AgendaRemoteDatasource({
    @required this.dio,
    @required this.profileRepository,
  });

  Future<List<AgendaEventRemoteModel>> getEvents({
    @required String start,
    @required String end,
  }) async {
    final studentId = await profileRepository.currentStudentId();
    final response = await dio.get(
      '/students/$studentId/agenda/all/$start/$end',
    );

    List<AgendaEventRemoteModel> events = List<AgendaEventRemoteModel>.from(
      response.data['agenda'].map(
        (i) => AgendaEventRemoteModel.fromJson(i),
      ),
    );

    return events;
  }
}
