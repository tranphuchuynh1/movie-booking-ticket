import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/features/home_movie/controllers/movie_service.dart';

class MovieController {
  final MovieService _movieService;

  MovieController({MovieService? movieService})
      : _movieService = movieService ?? MovieService(DioClient.instance);

  Future<Map<String, List<MovieModel>>> fetchMovies() async {
    try {
      final BaseResponse<List<MovieModel>> response = await _movieService.getMovies();
      final List<MovieModel> movies = response.data ?? [];

      final nowPlayingMovies = movies.where((movie) =>
      movie.status == 'Playing').toList();

      final upcomingMovies = movies.where((movie) =>
      movie.status == 'Upcoming').toList();

      final popularMovies = movies.where((movie) =>
      movie.rating != null && (movie.rating ?? 0) > 7.0).toList();

      return {
        'nowPlaying': nowPlayingMovies,
        'upcoming': upcomingMovies,
        'popular': popularMovies,
      };
    } catch (e) {
      throw Exception('Failed to fetch movies: ${e.toString()}');
    }
  }
}