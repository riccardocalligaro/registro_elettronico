import 'package:dio/dio.dart' hide Headers;
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/domain/entity/api_requests/login_request.dart';
import 'package:registro_elettronico/domain/entity/api_responses/absences_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/agenda_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/grades_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/lessons_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/noticeboard_read_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/noticeboard_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/periods_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/subjects_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

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

  // Subjects
  @GET("/students/{studentId}/subjects")
  Future<SubjectsResponse> getSubjects(@Path() String studentId);

  // Subjects
  @GET("/students/{studentId}/grades")
  Future<GradesResponse> getGrades(@Path() String studentId);

  // Subjects
  @GET("/students/{studentId}/agenda/all/{start}/{end}")
  Future<AgendaResponse> getAgenda(@Path() String studentId,
      @Path("start") String start, @Path("end") String end);

  // Absences
  @GET("/students/{studentId}/absences/details")
  Future<AbsencesResponse> getAbsences(@Path() String studentId);

  // Absences
  @GET("/students/{studentId}/periods")
  Future<PeriodsResponse> getPeriods(@Path() String studentId);

  // Notice board
  @GET("/students/{studentId}/noticeboard")
  Future<NoticeboardResponse> getNoticeBoard(@Path() String studentId);

  // Notice board
  @POST("/students/{studentId}/noticeboard/read/{eventCode}/{pubId}/101")
  Future<NoticeboardReadResponse> readNotice(
    @Path('studentId') String studentId,
    @Path('eventCode') String eventCode,
    @Path('pubId') String pubId,
    @Body() String body,
  );

  /// After the post request to read the notice you can get the attachment
  @GET(
      "/students/{studentId}/noticeboard/attach/{eventCode}/{pubId}/{attachNumber}")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getNotice(
    @Path('studentId') String studentId,
    @Path('eventCode') String eventCode,
    @Path('pubId') String pubId,
    @Path('attachNumber') String attachNum,
  );

  @GET("/students/{studentId}/notes/all/")
  Future<NotesResponse> getNotes(@Path() String studentId);

  // @POST("/students/{studentId}/notes/{type}/read/{layout_note}")
  // Future<Response> markNote(
  //   @Path('studentId') String studentId,
  //   @Path("type") String type,
  //   @Path("layout_note") int note,
  // );

  @GET("/students/{studentId}/didactics")
  Future<DidacticsResponse> getDidactics(@Path() String studentId);

  // @GET("/students/{studentId}/didactics/item/{fileId}")
  // @DioResponseType(ResponseType.bytes)
  // Future<Response<String>> getAttachmentFile(
  //     @Path() String studentId, @Path("fileId") int fileId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentURLResponse> getAttachmentUrl(
      @Path() String studentId, @Path("fileId") int fileId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentTextResponse> getAttachmentText(
      @Path() String studentId, @Path("fileId") int fileId);
}
