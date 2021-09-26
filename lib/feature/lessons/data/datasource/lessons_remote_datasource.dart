import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/lessons/data/model/lesson_remote_model.dart';

class LessonsRemoteDatasource {
  final Dio? dio;

  LessonsRemoteDatasource({
    required this.dio,
  });

  Future<List<LessonRemoteModel>> getTodayLessons() async {
    final response = await dio!.get('/students/{studentId}/lessons/today');

    List<LessonRemoteModel> lessons = List<LessonRemoteModel>.from(
      response.data['lessons'].map(
        (i) => LessonRemoteModel.fromJson(i),
      ),
    );

    return lessons;
  }

  Future<List<LessonRemoteModel>> getLessonBetweenDates(
    String start,
    String end,
  ) async {
    final response = await dio!.get('/students/{studentId}/lessons/$start/$end');

    List<LessonRemoteModel> lessons = List<LessonRemoteModel>.from(
      response.data['lessons'].map(
        (i) => LessonRemoteModel.fromJson(i),
      ),
    );

    return lessons;
  }
}
