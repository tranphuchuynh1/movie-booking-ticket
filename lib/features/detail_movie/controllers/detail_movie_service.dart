import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:retrofit/retrofit.dart';

part 'detail_movie_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MovieDetailService {
  factory MovieDetailService(Dio dio, {String baseUrl}) = _MovieDetailService;

  @GET('${ApiConstants.moviesEndpoint}/{id}')
  Future<MovieModel> getMovieDetail(@Path('id') String movieId);
}