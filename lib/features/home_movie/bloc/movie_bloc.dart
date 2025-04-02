import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/movie_model.dart';
import '../controllers/movie_controller.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieController _movieController;

  MovieBloc({MovieController? movieController})
      : _movieController = movieController ?? MovieController(),
        super(MovieState()) {
    on<FetchMoviesEvent>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
      FetchMoviesEvent event,
      Emitter<MovieState> emit
      ) async {
    emit(state.copyWith(status: MovieStatus.loading));

    try {
      final movieData = await _movieController.fetchMovies();

      emit(state.copyWith(
          status: MovieStatus.success,
          nowPlayingMovies: movieData['nowPlaying'],
          upcomingMovies: movieData['upcoming'],
          popularMovies: movieData['popular']
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovieStatus.error,
          errorMessage: e.toString()
      ));
    }
  }
}