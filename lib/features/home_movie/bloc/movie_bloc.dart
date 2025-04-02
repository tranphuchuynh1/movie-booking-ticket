import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';

import '../../../core/models/movie_model.dart';
import '../controllers/movie_controller.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieController _movieController = MovieController(dio: DioClient.instance);

  MovieBloc()
      : super(MovieState()) {
    on<FetchMoviesEvent>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
      FetchMoviesEvent event,
      Emitter<MovieState> emit
      ) async {
    emit(state.copyWith(status: MovieStateStatus.loading));

    try {
      final movieData = await _movieController.fetchMovies();
      var nowPlayingMovies = movieData.where((element) =>
          (element.status ?? '').toLowerCase().contains(
              MovieStatus.playing.name),).toList();
      var upcomingMovies = movieData.where((element) =>
          (element.status ?? '').toLowerCase().contains(
              MovieStatus.upcoming.name),).toList();
      var popularMovies = movieData.where((element) =>
      (element.rating ?? 0) >= 7.0,).toList();


      emit(state.copyWith(
          status: MovieStateStatus.success,
          nowPlayingMovies: nowPlayingMovies,
          upcomingMovies: upcomingMovies,
          popularMovies: popularMovies,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovieStateStatus.error,
          errorMessage: e.toString()
      ));
    }
  }
}