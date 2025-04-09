import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_event.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_state.dart';
import '../controllers/search_controller.dart';

class SearchBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchControllers _searchController;

  SearchBloc({SearchControllers? searchController})
    : _searchController = searchController ?? SearchControllers(),
      super(SearchMovieState()) {
    on<SearchMovieEvent>(_onSearchMovies);
  }

  Future<void> _onSearchMovies(
    SearchMovieEvent event,
    Emitter<SearchMovieState> emit,
  ) async {
    final trimmedQuery = event.query.trim();
    if (trimmedQuery.isEmpty) {
      emit(state.copyWith(status: SearchMovieStateStatus.loading));

      try {
        final List<MovieModel>? results = await _searchController.searchMovies(
          '',
        );
        results?.shuffle();
        emit(
          state.copyWith(
            status: SearchMovieStateStatus.success,
            searchResults: results,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: SearchMovieStateStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
      return;
    }

    emit(state.copyWith(status: SearchMovieStateStatus.loading));

    try {
      final List<MovieModel>? results = await _searchController.searchMovies(
        trimmedQuery,
      );
      emit(
        state.copyWith(
          status: SearchMovieStateStatus.success,
          searchResults: results,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchMovieStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
