import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/features/home_movie/controllers/movie_service.dart';
import 'package:movie_booking_ticket/utils/util.dart';

class MovieController {
  final MovieService _movieService;
  final Dio dio;

  MovieController({required this.dio}) : _movieService = MovieService(dio);



  Future<List<MovieModel>> fetchMovies() async {
    return handleResponse(await _movieService.getMovies());
  }
}