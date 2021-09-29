import 'package:dio/dio.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_remote_model.dart';

class GradesRemoteDatasource {
  final Dio? dio;
  final AuthenticationRepository? authenticationRepository;

  GradesRemoteDatasource({
    required this.dio,
    required this.authenticationRepository,
  });

  Future<List<GradeRemoteModel>> getGrades() async {
    final studentId = await authenticationRepository!.getCurrentStudentId();
    final response = await dio!.get('/students/$studentId/grades');

    List<GradeRemoteModel> grades = List<GradeRemoteModel>.from(
      response.data['grades'].map(
        (i) => GradeRemoteModel.fromJson(i),
      ),
    );

    return grades;
  }
}
