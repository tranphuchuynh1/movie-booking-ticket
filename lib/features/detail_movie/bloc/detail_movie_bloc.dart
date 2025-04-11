import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';

import '../controllers/detail_movie_controller.dart';

part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieDetailController _detailController = MovieDetailController(dio: DioClient.instance);

  MovieDetailBloc() : super(MovieDetailState()) {
    on<FetchMovieDetailEvent>(_onFetchMovieDetail);
  }

  Future<void> _onFetchMovieDetail(
      FetchMovieDetailEvent event,
      Emitter<MovieDetailState> emit
      ) async {
    emit(state.copyWith(status: MovieDetailStatus.loading));

    try {
      final movieDetail = await _detailController.fetchMovieDetail(event.movieId);

      emit(state.copyWith(
        status: MovieDetailStatus.success,
        movieDetail: movieDetail,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovieDetailStatus.error,
          errorMessage: e.toString()
      ));
    }
  }
}