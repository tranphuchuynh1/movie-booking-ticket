part of 'movie_bloc.dart';

enum MovieStatus { initial, loading, success, error }

class MovieState {
  final MovieStatus status;
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> upcomingMovies;
  final List<MovieModel> popularMovies;
  final String? errorMessage;

  MovieState({
    this.status = MovieStatus.initial,
    this.nowPlayingMovies = const [],
    this.upcomingMovies = const [],
    this.popularMovies = const [],
    this.errorMessage,
  });

  MovieState copyWith({
    MovieStatus? status,
    List<MovieModel>? nowPlayingMovies,
    List<MovieModel>? upcomingMovies,
    List<MovieModel>? popularMovies,
    String? errorMessage,
  }) {
    return MovieState(
      status: status ?? this.status,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}