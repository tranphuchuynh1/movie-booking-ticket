// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowtimeModel _$ShowtimeModelFromJson(Map<String, dynamic> json) =>
    ShowtimeModel(
      id: json['id'] as String?,
      roomId: json['roomId'] as String?,
      movieId: json['movieId'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      roomName: json['roomName'] as String?,
      movieImage: json['movieImage'] as String?,
    );

Map<String, dynamic> _$ShowtimeModelToJson(ShowtimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'movieId': instance.movieId,
      'date': instance.date,
      'time': instance.time,
      'price': instance.price,
      'roomName': instance.roomName,
      'movieImage': instance.movieImage,
    };

SeatModel _$SeatModelFromJson(Map<String, dynamic> json) => SeatModel(
  seatId: json['seatId'] as String?,
  row: json['row'] as String?,
  number: (json['number'] as num?)?.toInt(),
  type: json['type'] as String?,
  priceModifier: (json['priceModifier'] as num?)?.toDouble(),
  roomName: json['roomName'] as String?,
);

Map<String, dynamic> _$SeatModelToJson(SeatModel instance) => <String, dynamic>{
  'seatId': instance.seatId,
  'row': instance.row,
  'number': instance.number,
  'type': instance.type,
  'priceModifier': instance.priceModifier,
  'roomName': instance.roomName,
};
