import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/detail_movie/controllers/detail_movie_service.dart';

class MovieDetailController {
  final MovieDetailService _detailService;
  final Dio dio;

  MovieDetailController({required this.dio}) : _detailService = MovieDetailService(dio);

  Future<MovieModel> fetchMovieDetail(String movieId) async {
    try {
      final movieModel = await _detailService.getMovieDetail(movieId);
      return movieModel;
    } catch (e) {
      throw Exception('Không thể lấy thông tin phim: ${e.toString()}');
    }
  }
}