
import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/auth/register_model.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/auth/login_model.dart';
part 'auth_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST(ApiConstants.loginEndpoint)
  Future<UserModel> login(@Body() LoginModel loginModel);

  @POST(ApiConstants.registerEndpoint)
  Future<UserModel> register(@Body() RegisterModel registerModel);

}