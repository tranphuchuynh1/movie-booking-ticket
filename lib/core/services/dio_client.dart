import 'package:dio/dio.dart';

import '../constants/constants.dart';


class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE: ${response.statusCode}');
          print('DATA: ${response.data}');
          return handler.next(response);
        },



        onError: (DioException e, handler) {
          print('ERROR: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get instance => _instance.dio;
}