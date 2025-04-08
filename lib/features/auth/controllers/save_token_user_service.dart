import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';

class SaveTokenUserService {
  static const String _userKey = 'key_save_data_user';

  // save thông tin user
  static Future<bool> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(user.toJson());
      return await prefs.setString(_userKey, userData);
    } catch (e) {
      print('Lỗi khi lưu user: $e');
      return false;
    }
  }

  // Lấy thông tin user
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData == null) return null;

      final userMap = jsonDecode(userData) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('Lỗi khi lấy user: $e');
      return null;
    }
  }

  // delete thông tin user khi đăng xuất
  static Future<bool> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Lỗi khi xóa user: $e');
      return false;
    }
  }

  // check token có hợp lệ không
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null && user.isTokenValid;
  }
}