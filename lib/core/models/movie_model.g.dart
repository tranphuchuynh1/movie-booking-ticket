// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  movieId: json['movieId'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  nation: json['nation'] as String?,
  status: json['status'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  releaseDate: json['releaseDate'] as String?,
  ageRating: json['ageRating'] as String?,
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  actors:
      (json['actors'] as List<dynamic>?)
          ?.map((e) => ActorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  trailerUrl: json['trailerUrl'] as String?,
  imageMovie:
      (json['imageMovie'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'description': instance.description,
      'nation': instance.nation,
      'status': instance.status,
      'duration': instance.duration,
      'rating': instance.rating,
      'releaseDate': instance.releaseDate,
      'ageRating': instance.ageRating,
      'genres': instance.genres,
      'media': instance.media,
      'actors': instance.actors,
      'trailerUrl': instance.trailerUrl,
      'imageMovie': instance.imageMovie,
    };

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
  id: json['id'] as String?,
  movieId: json['movieId'] as String?,
  description: json['description'] as String?,
  mediaType: json['mediaType'] as String?,
  mediaURL: json['mediaURL'] as String?,
);

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'description': instance.description,
      'mediaType': instance.mediaType,
      'mediaURL': instance.mediaURL,
    };

ActorModel _$ActorModelFromJson(Map<String, dynamic> json) => ActorModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  imageURL: json['imageURL'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$ActorModelToJson(ActorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageURL': instance.imageURL,
      'role': instance.role,
    };
