
import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/models/base_response.dart';
part 'movie_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MovieService {
  factory MovieService (Dio dio, {String baseUrl}) = _MovieService;

  @GET(ApiConstants.moviesEndpoint)
  Future<BaseResponse<List<MovieModel>>> getMovies();
}