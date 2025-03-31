import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/movie_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/dio_client.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieState()) {
    on<FetchMoviesEvent>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
      FetchMoviesEvent event,
      Emitter<MovieState> emit
      ) async {
    emit(state.copyWith(status: MovieStatus.loading));

    try {
      final dio = DioClient.instance;
      final apiService = ApiService(dio);

      final response = await apiService.getMovies();
      final List<dynamic> movieData = response['data'];

      final movies = movieData.map((json) => MovieModel.fromJson(json)).toList();

      final nowPlayingMovies = movies.where((movie) =>
      movie.status == 'Playing').toList();

      final upcomingMovies = movies.where((movie) =>
      movie.status == 'Upcoming').toList();

      final popularMovies = movies.where((movie) =>
      movie.rating != null && (movie.rating ?? 0) > 7.0).toList();

      emit(state.copyWith(
          status: MovieStatus.success,
          nowPlayingMovies: nowPlayingMovies,
          upcomingMovies: upcomingMovies,
          popularMovies: popularMovies
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovieStatus.error,
          errorMessage: e.toString()
      ));
    }
  }
}