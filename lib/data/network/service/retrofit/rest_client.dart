import 'package:dio/dio.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/data/network/service/retrofit/entities/login_response.dart';
import 'package:retrofit/http.dart';

import 'entities/login_request.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: '${ApiConfig.BASE_API_URL}')
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  // ----------- Log in Path -----------
  @POST("/auth/login")
  Future<LoginResponse> loginUser(@Body() String body);
}
