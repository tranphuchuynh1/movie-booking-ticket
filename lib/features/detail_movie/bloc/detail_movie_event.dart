part of 'detail_movie_bloc.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final String movieId;

  FetchMovieDetailEvent(this.movieId);
}