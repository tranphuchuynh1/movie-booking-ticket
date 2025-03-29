import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/constants.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.moviesEndpoint)
  Future<Map<String, dynamic>> getMovies();

  // muốn Get data cho api nào thì tạo endpoint mới ở constants.dart nha chị nhàn(nhớ tạo model)

}