import 'package:dio/dio.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';

class AgendaRemoteDatasource {
  final Dio? dio;
  final AuthenticationRepository? authenticationRepository;

  AgendaRemoteDatasource({
    required this.dio,
    required this.authenticationRepository,
  });

  Future<List<AgendaEventRemoteModel>> getEvents({
    required String start,
    required String end,
  }) async {
    final studentId = await authenticationRepository!.getCurrentStudentId();

    final response = await dio!.get(
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
