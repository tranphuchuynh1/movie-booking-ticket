import 'package:movie_booking_ticket/features/home_movie/bloc/movie_bloc.dart';

class SearchMovieEvent extends MovieEvent {
  final String query;
  SearchMovieEvent(this.query);
}
