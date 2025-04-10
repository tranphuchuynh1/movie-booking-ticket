part of 'detail_movie_bloc.dart';

enum MovieDetailStatus { initial, loading, success, error }

class MovieDetailState {
  final MovieDetailStatus status;
  final MovieModel? movieDetail;
  final String? errorMessage;

  MovieDetailState({
    this.status = MovieDetailStatus.initial,
    this.movieDetail,
    this.errorMessage,
  });

  MovieDetailState copyWith({
    MovieDetailStatus? status,
    MovieModel? movieDetail,
    String? errorMessage,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      movieDetail: movieDetail ?? this.movieDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}