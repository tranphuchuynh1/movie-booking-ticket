import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

enum MovieStatus { playing, upcoming }

@JsonSerializable()
class MovieModel {
  @JsonKey(name: 'movieId')
  final String? movieId;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'nation')
  final String? nation;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'duration')
  final int? duration;

  @JsonKey(name: 'rating')
  final double? rating;

  @JsonKey(name: 'releaseDate')
  final String? releaseDate;

  @JsonKey(name: 'ageRating')
  final String? ageRating;

  @JsonKey(name: 'genres')
  final List<String>? genres;

  @JsonKey(name: 'media')
  final List<MediaModel>? media;

  @JsonKey(name: 'actors')
  final List<ActorModel>? actors;

  @JsonKey(name: 'orders')
  final List<OrderModel>? orders;

  String? trailerUrl;
  List<String>? imageMovie;

  MovieModel({
    this.movieId,
    this.title,
    this.description,
    this.nation,
    this.status,
    this.duration,
    this.rating,
    this.releaseDate,
    this.ageRating,
    this.genres,
    this.media,
    this.actors,
    this.trailerUrl,
    this.imageMovie,
    this.orders,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final model = _$MovieModelFromJson(json);

    // handle media để lấy trailerUrl và imageMovie
    if (model.media != null && model.media!.isNotEmpty) {
      List<String> images = [];

      for (var mediaItem in model.media!) {
        if (mediaItem.mediaType == 'Video') {
          model.trailerUrl = mediaItem.mediaURL;
        } else if (mediaItem.mediaType == 'Image') {
          images.add(mediaItem.mediaURL ?? '');
        }
      }

      model.imageMovie = images;
    }

    return model;
  }

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  MovieModel copyWith({
    String? movieId,
    String? title,
    String? description,
    String? nation,
    String? status,
    int? duration,
    double? rating,
    String? releaseDate,
    String? ageRating,
    List<String>? genres,
    List<MediaModel>? media,
    List<ActorModel>? actors,
    String? trailerUrl,
    List<String>? imageMovie,
    List<OrderModel>? orders,
    List<MovieTicketModel>? images,
  }) {
    return MovieModel(
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      description: description ?? this.description,
      nation: nation ?? this.nation,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      ageRating: ageRating ?? this.ageRating,
      genres: genres ?? this.genres,
      media: media ?? this.media,
      actors: actors ?? this.actors,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      imageMovie: imageMovie ?? this.imageMovie,
      orders: orders ?? this.orders,
    );
  }
}

@JsonSerializable()
class MediaModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'movieId')
  final String? movieId;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'mediaType')
  final String? mediaType;

  @JsonKey(name: 'mediaURL')
  final String? mediaURL;

  MediaModel({
    this.id,
    this.movieId,
    this.description,
    this.mediaType,
    this.mediaURL,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MediaModelToJson(this);
}

@JsonSerializable()
class ActorModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'imageURL')
  final String? imageURL;

  @JsonKey(name: 'role')
  final String? role;

  ActorModel({this.id, this.name, this.imageURL, this.role});

  factory ActorModel.fromJson(Map<String, dynamic> json) =>
      _$ActorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActorModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'movie')
  final MovieModel? movie;

  @JsonKey(name: 'orderDate')
  final String? orderDate;

  OrderModel({this.orderId, this.userId, this.movie, this.orderDate});

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class MovieTicketModel {
  @JsonKey(name: 'movieId')
  final String? movieId;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'status')
  final String? status;

  MovieTicketModel({this.movieId, this.title, this.image, this.status});

  factory MovieTicketModel.fromJson(Map<String, dynamic> json) =>
      _$MovieTicketModelFromJson(json);
  Map<String, dynamic> toJson() => _$MovieTicketModelToJson(this);
}

@JsonSerializable()
class MyTicketModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'imageMovie')
  final String? imageMovie;

  @JsonKey(name: 'hall')
  final String? hall;

  @JsonKey(name: 'showTimeDate')
  final String? showTimeDate;

  @JsonKey(name: 'showTimeStart')
  final String? showTimeStart;

  @JsonKey(name: 'seatRow')
  final String? seatRow;

  @JsonKey(name: 'seatNumber')
  final int? seatNumber;

  @JsonKey(name: 'qrCode')
  final String? qrCode;

  MyTicketModel({
    this.id,
    this.imageMovie,
    this.hall,
    this.showTimeDate,
    this.showTimeStart,
    this.seatRow,
    this.seatNumber,
    this.qrCode,
  });

  factory MyTicketModel.fromJson(Map<String, dynamic> json) =>
      _$MyTicketModelFromJson(json);
  Map<String, dynamic> toJson() => _$MyTicketModelToJson(this);
}
