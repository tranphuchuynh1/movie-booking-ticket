// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  movieId: json['movieId'] as String?,
  title: json['title'] as String?,
  nation: json['nation'] as String?,
  releaseDate: json['releaseDate'] as String?,
  status: json['status'] as String?,
  rating: json['rating'] as num?,
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  imageMovie:
      (json['imageMovie'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'nation': instance.nation,
      'releaseDate': instance.releaseDate,
      'status': instance.status,
      'rating': instance.rating,
      'genres': instance.genres,
      'imageMovie': instance.imageMovie,
    };
