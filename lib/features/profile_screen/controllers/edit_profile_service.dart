import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:io';

import '../../../core/constants/constants.dart';

part 'edit_profile_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class EditProfileService {
  factory EditProfileService(Dio dio, {String baseUrl}) = _EditProfileService;

  @GET(ApiConstants.getProfileEndpoint)
  Future<UserModel> getProfile(@Path('userId') String userId);

  @PUT(ApiConstants.updateProfileEndpoint)
  Future<UserModel> updateProfile(@Body() Map<String, dynamic> userData);

  @POST(ApiConstants.updateAvatarEndpoint)
  Future<Map<String, String>> updateAvatar(@Part(name: 'Avatar') File avatar);


}