import '../models/movie.dart';
import '../models/cast.dart';
import 'cast_data.dart';
import 'movie_data.dart';

class FakeData {
  static final FakeData _data = FakeData.app();
  factory FakeData() => _data;
  FakeData.app();

  // Detailed movie data
  final List<Movie> movie = [];

  // Initialize data
  void loadDataIfNeeded() {
    if (movie.isNotEmpty) return;

    final CastData castData = CastData();
    final MoviesData moviesData = MoviesData(castData);
    
    movie.addAll(moviesData.getAllMovies());
  }

  // Public methods to access data
  List<Movie> getNowPlayingMovies() {
    loadDataIfNeeded();
    return movie;
  }

  List<Movie> getPopularMovies() {
    loadDataIfNeeded();
    return movie;
  }

  List<Movie> getUpcomingMovies() {
    loadDataIfNeeded();
    return movie;
  }

  Movie getMovieByTitle(String title) {
    loadDataIfNeeded();
    return movie.firstWhere(
          (movie) => movie.title == title,
      orElse: () => movie.first,
    );
  }

}