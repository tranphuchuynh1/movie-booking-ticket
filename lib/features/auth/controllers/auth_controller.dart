

import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/auth/login_model.dart';
import 'package:movie_booking_ticket/core/models/auth/register_model.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';
import 'package:movie_booking_ticket/features/auth/controllers/auth_service.dart';

class AuthController {
  final AuthService _authService;
  final Dio dio;

  AuthController({required this.dio}) : _authService = AuthService(dio);

  Future<UserModel> login(String userName, String password) async {
    final loginModel = LoginModel(userName: userName, password: password);
    return await _authService.login(loginModel);
  }

  Future<UserModel> register(String userName, String email, String password, String confirmPassword) async {
    final registerModel = RegisterModel(
        userName: userName,
        email: email,
        password: password,
        confirmPassword: confirmPassword
    );
    return await _authService.register(registerModel);
  }
}