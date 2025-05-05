import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../auth/controllers/save_token_user_service.dart';
import 'change_password_service.dart';
import '../../../core/constants/constants.dart';

class ChangePasswordController {
  final ChangePasswordService _changePasswordService;
  final Dio dio;

  ChangePasswordController({Dio? providedDio})
      : dio = providedDio ?? Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,  // Thêm baseUrl
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    headers: {
      'Content-Type': 'application/json',
    },
  )),
        _changePasswordService = ChangePasswordService(
            providedDio ?? Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,  // Thêm baseUrl
              connectTimeout: const Duration(milliseconds: 30000),
              receiveTimeout: const Duration(milliseconds: 30000),
              headers: {
                'Content-Type': 'application/json',
              },
            ))
        ) {
    // Thêm interceptor để debug
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,  // Thêm log cho header request
      responseHeader: true, // Thêm log cho header response
    ));
  }

  // Phương thức xác thực và validate password không thay đổi
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (password.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    // Kiểm tra có ít nhất 1 chữ số
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ số';
    }

    // Kiểm tra có ít nhất 1 chữ cái thường
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ cái thường';
    }

    // Kiểm tra có ít nhất 1 chữ cái in hoa
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ cái in hoa';
    }

    // Kiểm tra có ít nhất 1 ký tự đặc biệt
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (!@#%^&*(),.?":{}|<>)';
    }

    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Xác nhận mật khẩu không được để trống';
    }
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  // Change password - Đã sửa lại
  Future<bool> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Lấy token mới nhất
      final token = await SaveTokenUserService.getAccessToken();
      if (token == null) {
        throw Exception('Phiên đăng nhập hết hạn, vui lòng đăng nhập lại');
      }

      // In request để debug
      debugPrint('Đổi mật khẩu cho user: $userId');
      debugPrint('Mật khẩu hiện tại: $currentPassword');

      // Tạo URL đầy đủ với baseUrl
      final fullUrl = 'https://movieticketsv1.runasp.net/api/account/change-password';

      // Cập nhật header với token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // In thông tin để debug
      debugPrint('Gọi API đổi mật khẩu với URL đầy đủ: $fullUrl');

      // Tạo request body đúng cấu trúc - CHỈ gửi các trường API yêu cầu
      final passwordData = {
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': newPassword
      };

      // Thay vì sử dụng service, gọi trực tiếp bằng Dio để có thể debug tốt hơn
      final response = await dio.post(
        fullUrl,  // Dùng URL đầy đủ
        data: passwordData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Log response để debug
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Có lỗi xảy ra khi đổi mật khẩu');
      }
    } on DioException catch (e) {
      debugPrint('Error type: ${e.type}');
      debugPrint('Error changing password: ${e.response?.statusCode} - ${e.response?.data}');

      if (e.response?.statusCode == 400) {
        // Sửa thông báo lỗi tại đây
        throw Exception('Bạn đã nhập sai mật khẩu hiện tại');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn, vui lòng đăng nhập lại');
      } else {
        throw Exception('Không thể đổi mật khẩu. Vui lòng thử lại sau.');
      }
    } catch (e) {
      debugPrint('Error changing password: $e');
      throw Exception('Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.');
    }
  }
}