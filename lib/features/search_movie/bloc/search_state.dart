import 'package:movie_booking_ticket/core/models/movie_model.dart';

enum SearchMovieStateStatus { initial, loading, success, error }

class SearchMovieState {
  final SearchMovieStateStatus status;
  final List<MovieModel> searchResults;
  final String? errorMessage;

  SearchMovieState({
    this.status = SearchMovieStateStatus.initial,
    this.searchResults = const [],
    this.errorMessage,
  });

  SearchMovieState copyWith({
    SearchMovieStateStatus? status,
    List<MovieModel>? searchResults,
    String? errorMessage,
  }) {
    return SearchMovieState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
