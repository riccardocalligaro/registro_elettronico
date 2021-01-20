import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_remote_model.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';

class GradesRemoteDatasource {
  final Dio dio;
  final ProfileRepository profileRepository;

  GradesRemoteDatasource({
    @required this.dio,
    @required this.profileRepository,
  });

  Future<List<GradeRemoteModel>> getGrades() async {
    final studentId = await profileRepository.currentStudentId();
    final response = await dio.get('/students/$studentId/grades');

    List<GradeRemoteModel> grades = List<GradeRemoteModel>.from(
      response.data['grades'].map(
        (i) => GradeRemoteModel.fromJson(i),
      ),
    );

    return grades;
  }
}
