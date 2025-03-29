
import 'cast.dart';

class Movie {
  final String title;
  final String posterUrl;
  final double rating;
  final int voteCount;
  final String releaseDate;
  final String duration;
  final List<String> genres;
  final String tagline;
  final String plot;
  final List<Cast> cast;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.voteCount,
    required this.releaseDate,
    required this.duration,
    required this.genres,
    required this.tagline,
    required this.plot,
    required this.cast
  });
}