// file: lib/data/movies_data.dart
import '../models/movie.dart';
import 'cast_data.dart';

class MoviesData {
  final CastData _castData;

  MoviesData(this._castData);

  List<Movie> getAllMovies() {
    final List<Movie> movies = [];

    // Add John Wick movie
    movies.add(_getJohnWickMovie());

    // Add Shazam movie
    movies.add(_getShazamMovie());

    // Add Doraemon movie
    movies.addAll(_getDoraemon());

    // Add BoGia movie
    movies.addAll(_getBoGia());

    // Add SpiderMan movie
    movies.addAll(_getSpiderMan());

    return movies;
  }

  Movie _getJohnWickMovie() {
    return Movie(
      title: 'John Wick: Chapter 4',
      posterUrl: 'assets/images/john.jpg',
      rating: 8.0,
      voteCount: 1024,
      releaseDate: '24 March 2023',
      duration: '2h 50m',
      genres: ['Action', 'Thriller', 'Crime'],
      tagline: 'No way back, one way out.',
      plot:
      'With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.',
      cast: _castData.getJohnWickCast(),
    );
  }

  Movie _getShazamMovie() {
    return Movie(
      title: 'Shazam',
      posterUrl: 'assets/images/shazam.jpeg',
      rating: 7.5,
      voteCount: 950,
      releaseDate: '5 April 2023',
      duration: '2h 12m',
      genres: ['Action', 'Adventure', 'Comedy'],
      tagline: 'Just say the word.',
      plot:
      'A boy is given the ability to become an adult superhero in times of need with a single magic word.',
      cast: _castData.getShazamCast(),
    );
  }

  List<Movie> _getDoraemon() {
    return [
      Movie(
        title: 'Doraemon: Music World',
        posterUrl: 'assets/images/dora.png',
        rating: 7.8,
        voteCount: 820,
        releaseDate: '10 May 2023',
        duration: '2h 05m',
        genres: ['Comedy', 'Action','Adventure','Fantasy'],
        tagline: 'A dramatic tagline.',
        plot:
        'A gripping story about overcoming adversity and finding strength in unexpected places.',
        cast: _castData.getDoraemon(),
      ),
    ];
  }

  List<Movie> _getBoGia() {
    return [
      Movie(
        title: 'Bố Già',
        posterUrl: 'assets/images/bogia.jpeg',
        rating: 7.8,
        voteCount: 820,
        releaseDate: '10 May 2023',
        duration: '1h 45m',
        genres: ['Drama', 'Action'],
        tagline: 'A dramatic tagline.',
        plot:
        'A gripping story about overcoming adversity and finding strength in unexpected places.',
        cast: _castData.getBoGia(),
      ),
    ];
  }

  List<Movie> _getSpiderMan() {
    return [
      Movie(
        title: 'SpiderMan',
        posterUrl: 'assets/images/spider.jpg',
        rating: 7.8,
        voteCount: 820,
        releaseDate: '10 May 2023',
        duration: '3h 55m',
        genres: ['Superhero', 'Action','Animal','Fantasy'],
        tagline: 'A dramatic tagline.',
        plot:
        'Spider-Man is a fictional superhero in comic books published by Marvel Comics. '
            'This character was created by writer Stan Lee and writer-artist.',
        cast: _castData.getSpiderMan(),
      ),
    ];
  }

}