import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  // late final ApiService apiService; -> nào có class ApiService thì dùng

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    // apiService = ApiService(dio);  - > ApiService có thì dùng
  }

  static Dio get instance => _instance.dio;
}
