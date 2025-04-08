import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';

class SaveTokenUserService {
  static const String USER_KEY = 'key_save_data_user';

  // save thông tin user
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_KEY, jsonEncode(user.toJson()));
  }

  // Lấy thông tin user
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(USER_KEY);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // delete thông tin user khi logout
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_KEY);
  }

  // check user dùng đã login và token còn hiệu lực hay k
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    if (user == null || user.jwtToken == null || user.expireTime == null) {
      return false;
    }

    // check time hạn của token
    final expireTime = DateTime.parse(user.expireTime!);
    final now = DateTime.now();
    return expireTime.isAfter(now);
  }
}