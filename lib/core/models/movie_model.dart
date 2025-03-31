
import 'package:json_annotation/json_annotation.dart';
part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: 'movieId')
  final String? movieId;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'nation')
  final String? nation;

  @JsonKey(name: 'releaseDate')
  final String? releaseDate;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'rating')
  final num? rating;

  @JsonKey(name: 'genres')
  final List<String>? genres;

  @JsonKey(name: 'imageMovie')
  final List<String>? imageMovie;


  MovieModel({
      this.movieId,
      this.title,
      this.nation,
      this.releaseDate,
      this.status,
      this.rating,
      this.genres,
      this.imageMovie,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

}