import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_remote_model.dart';

class SubjectsRemoteDatasource {
  final Dio dio;

  SubjectsRemoteDatasource({
    @required this.dio,
  });

  Future<List<SubjectRemoteModel>> getSubjects() async {
    final response = await dio.get('/students/{studentId}/subjects');

    List<SubjectRemoteModel> subjects = List<SubjectRemoteModel>.from(
      response.data['subjects'].map(
        (i) => SubjectRemoteModel.fromJson(i),
      ),
    );

    return subjects;
  }
}
