import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/search_movie/controllers/search_service.dart';

class SearchControllers {
  final SearchService _searchService;
  SearchControllers({Dio? dio}) : _searchService = SearchService(dio ?? Dio());

  Future<List<MovieModel>?> searchMovies(String query) async {
    try {
      final BaseResponse<List<MovieModel>> response = await _searchService
          .searchMovies(query);
      if (response.success == true && response.data != null) {
        return response.data;
      } else {
        throw Exception(
          "Search movies failed: ${response.message ?? response.error}",
        );
      }
    } catch (e) {
      return [];
    }
  }
}
