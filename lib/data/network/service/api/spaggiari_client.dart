import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/domain/entity/lesson.dart';
import 'package:registro_elettronico/domain/entity/login_request.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:retrofit/http.dart';

part 'spaggiari_client.g.dart';

@RestApi(baseUrl: '${ApiConfig.BASE_API_URL}')
abstract class SpaggiariClient {
  // static Dio dio;
  // Dio dioCreated = DioClient().createDio();
  factory SpaggiariClient(Dio dio) = _SpaggiariClient;

  // ----------- Log in Path -----------
  @POST("/auth/login")
  Future<LoginResponse> loginUser(@Body() LoginRequest loginRequest);

  // ----------- Lessons -----------
  @GET("/students/{studentId}/lessons/20191108/20191109")
  Future<List<Lesson>> getTodayLessons(@Path() String studentId);
}
