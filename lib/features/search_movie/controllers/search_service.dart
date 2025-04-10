import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:retrofit/retrofit.dart';

part 'search_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SearchService {
  factory SearchService(Dio dio, {String baseUrl}) = _SearchService;

  @GET(ApiConstants.moviesEndpoint)
  Future<BaseResponse<List<MovieModel>>> searchMovies(
    @Query('Search') String query,
  );
}
