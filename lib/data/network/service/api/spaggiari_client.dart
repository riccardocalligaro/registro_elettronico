import 'package:dio/dio.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/domain/entity/lessons_response.dart';
import 'package:registro_elettronico/domain/entity/login_request.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/entity/subjects/subjects_response.dart';
import 'package:retrofit/http.dart';

part 'spaggiari_client.g.dart';

@RestApi(baseUrl: '${ApiConfig.BASE_API_URL}')
abstract class SpaggiariClient {
  factory SpaggiariClient(Dio dio) = _SpaggiariClient;

  /// Log in path
  @POST("/auth/login")
  Future<LoginResponse> loginUser(@Body() LoginRequest loginRequest);

  /// Gets lesson of today
  @GET("/students/{studentId}/lessons/today")
  Future<LessonsResponse> getTodayLessons(@Path() String studentId);

  /// Gets lesson between date 1 and date 2
  @GET("/students/{studentId}/lessons/{start}/{end}")
  Future<LessonsResponse> getLessonBetweenDates(@Path() String studentId,
      @Path("start") String start, @Path("end") String end);

  // ----------- Subjects -----------
  @GET("/students/{studentId}/subjects")
  Future<SubjectsResponse> getSubjects(@Path() String studentId);
}
