import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';

import '../../../core/constants/constants.dart';
import '../../auth/controllers/save_token_user_service.dart';
import 'edit_profile_service.dart';

class EditProfileController {
  late EditProfileService _editProfileService;
  late Dio _dio;
  bool _isInitialized = false;
  UserModel? _currentUser;

  EditProfileController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      // Lấy thông tin người dùng hiện tại
      _currentUser = await SaveTokenUserService.getUser();
      await _initializeDio();
    } catch (e) {
      debugPrint('Lỗi khởi tạo controller: $e');
    }
  }

  Future<void> _initializeDio() async {
    try {
      // Lấy token xác thực
      final token = await SaveTokenUserService.getAccessToken();

      // Tạo đối tượng Dio với options chi tiết hơn
      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return status != null && status < 500; // Chấp nhận cả lỗi 4xx để xử lý
        },
        followRedirects: true,
        receiveDataWhenStatusError: true,
      ));

      // Thêm interceptor để log chi tiết
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));

      // Khởi tạo service
      _editProfileService = EditProfileService(_dio);

      _isInitialized = true;
      debugPrint('EditProfileController đã được khởi tạo với token xác thực');
    } catch (e) {
      debugPrint('Lỗi khi khởi tạo Dio: $e');
      // Khởi tạo không có token nếu có lỗi
      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ));
      _editProfileService = EditProfileService(_dio);
      _isInitialized = true;
    }
  }

  // Đảm bảo controller đã được khởi tạo và token hợp lệ
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeDio();
    }
  }

  // Get user profile from API
  Future<UserModel?> getUserProfile(String userId) async {
    await _ensureInitialized();

    try {
      debugPrint('Đang lấy thông tin người dùng với userId: $userId');
      // Gọi trực tiếp API để luôn lấy thông tin mới nhất
      final response = await _dio.get(
        ApiConstants.getProfileEndpoint.replaceAll('{userId}', userId),
      );

      if (response.statusCode == 200) {
        final userProfile = UserModel.fromJson(response.data);

        // Cập nhật vào local storage
        await SaveTokenUserService.saveUser(userProfile);

        return userProfile;
      }

      return null;
    } on DioException catch (e) {
      debugPrint('API Error khi lấy thông tin: ${e.response?.statusCode} - ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        debugPrint('Token không hợp lệ hoặc đã hết hạn');
        // Token không hợp lệ, thử khởi tạo lại
        _isInitialized = false;
        await _initializeDio();
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Update profile info (name, email, phone)
  Future<UserModel?> updateProfileInfo({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String avatarUrl,
  }) async {
    await _ensureInitialized();

    try {
      debugPrint('Đang cập nhật thông tin người dùng:');
      debugPrint('userId: $userId');
      debugPrint('fullName: $fullName');
      debugPrint('phoneNumber: $phoneNumber');
      debugPrint('avatarUrl: $avatarUrl');

      final userData = {
        'userId': userId,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'avatarUrl': avatarUrl,
      };

      // Thêm retry logic để thử lại nếu thất bại
      int retryCount = 0;
      const maxRetries = 2;

      while (retryCount <= maxRetries) {
        try {
          final updatedUser = await _editProfileService.updateProfile(userData);

          debugPrint('Cập nhật thành công, đang lưu vào local storage');
          // Save the updated user to local storage
          await SaveTokenUserService.saveUser(updatedUser);

          return updatedUser;
        } on DioException catch (e) {
          debugPrint('Attempt ${retryCount + 1} failed: ${e.message}');
          debugPrint('Response: ${e.response?.data}');

          if (retryCount == maxRetries) throw e;
          retryCount++;
          await Future.delayed(Duration(seconds: 1 * retryCount));
        }
      }

      return null;
    } on DioException catch (e) {
      debugPrint('API Error khi cập nhật: ${e.response?.statusCode} - ${e.response?.data}');
      debugPrint('Error type: ${e.type}');
      debugPrint('Error message: ${e.message}');

      // Xử lý các trường hợp lỗi cụ thể
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Kết nối đến máy chủ quá lâu. Vui lòng thử lại sau.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.');
      }

      return null;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return null;
    }
  }

  // Upload avatar and get avatar URL
  Future<String?> uploadAvatar(File imageFile) async {
    try {
      // Đảm bảo khởi tạo với token mới nhất
      await _ensureInitialized();

      debugPrint('Đang tải lên ảnh đại diện: ${imageFile.path}');

      // Tạo form data
      final formData = FormData.fromMap({
        'Avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Lấy token xác thực
      final token = await SaveTokenUserService.getAccessToken();

      // Tạo URL đầy đủ - đây là phần quan trọng
      final fullUrl = '${ApiConstants.baseUrl}${ApiConstants.updateAvatarEndpoint}';
      debugPrint('Gọi API upload avatar tại URL: $fullUrl');

      // Gọi API với header Authorization
      final response = await _dio.post(
        fullUrl, // Sử dụng URL đầy đủ
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      // Xử lý kết quả
      if (response.statusCode == 200) {
        if (response.data is Map) {
          final avatarUrl = response.data['avatarUrl'];
          if (avatarUrl != null) {
            debugPrint('Đã lấy được avatarUrl mới: $avatarUrl');
            return avatarUrl;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  // Complete profile update process (update avatar if needed and then update profile)
  Future<UserModel?> completeProfileUpdate({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String currentAvatarUrl,
    File? newAvatarImage,
  }) async {
    try {
      debugPrint('Bắt đầu quy trình cập nhật hồ sơ hoàn chỉnh');
      String avatarUrl = currentAvatarUrl;

      // Upload new avatar if provided
      if (newAvatarImage != null) {
        final newAvatarUrl = await uploadAvatar(newAvatarImage);
        if (newAvatarUrl != null && newAvatarUrl.isNotEmpty) {
          avatarUrl = newAvatarUrl;
          debugPrint('Đã cập nhật URL avatar mới: $avatarUrl');

          // Cập nhật vào user model tạm thời
          if (_currentUser != null) {
            _currentUser = _currentUser!.copyWith(avatarUrl: avatarUrl);
            // Lưu ngay lập tức để đảm bảo không mất thông tin
            await SaveTokenUserService.saveUser(_currentUser!);
          }
        }
      }

      // Update profile with all information (including new avatar if uploaded)
      debugPrint('Đang cập nhật hồ sơ với thông tin đầy đủ');
      final updatedUser = await updateProfileInfo(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );

      if (updatedUser != null) {
        debugPrint('Cập nhật hồ sơ thành công');
        _currentUser = updatedUser;
        return updatedUser;
      } else {
        debugPrint('Cập nhật hồ sơ thất bại');
        // Chỉ khi updateProfileInfo trả về null thì mới tạo manually
        final manuallyUpdatedUser = UserModel(
          userId: userId,
          userName: _currentUser?.userName ?? '',
          email: _currentUser?.email ?? '',
          fullName: fullName,
          phoneNumber: phoneNumber,
          avatarUrl: avatarUrl,
        );

        // Lưu vào local storage
        await SaveTokenUserService.saveUser(manuallyUpdatedUser);
        return manuallyUpdatedUser;
      }
    } catch (e) {
      debugPrint('Error in complete profile update: $e');
      return null;
    }
  }
}