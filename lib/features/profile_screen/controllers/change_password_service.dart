import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/constants.dart';

part 'change_password_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ChangePasswordService {
  factory ChangePasswordService(Dio dio, {String baseUrl}) = _ChangePasswordService;

  Dio get client;

  @POST(ApiConstants.changePasswordEndpoint)
  Future<void> changePassword(@Body() Map<String, dynamic> passwordData);
}