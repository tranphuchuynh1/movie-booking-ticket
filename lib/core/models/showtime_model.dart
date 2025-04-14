import 'package:json_annotation/json_annotation.dart';

part 'showtime_model.g.dart';

@JsonSerializable()
class ShowtimeModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'roomId')
  final String? roomId;

  @JsonKey(name: 'movieId')
  final String? movieId;

  @JsonKey(name: 'date')
  final String? date;

  @JsonKey(name: 'time')
  final String? time;

  @JsonKey(name: 'price')
  final double? price;

  @JsonKey(name: 'roomName')
  final String? roomName;

  @JsonKey(name: 'movieImage')
  final String? movieImage;

  ShowtimeModel({
    this.id,
    this.roomId,
    this.movieId,
    this.date,
    this.time,
    this.price,
    this.roomName,
    this.movieImage,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) => _$ShowtimeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowtimeModelToJson(this);

  DateTime? get dateTime {
    if (date == null || time == null) return null;
    try {
      final dateParts = date!.split('-');
      final timeParts = time!.split(':');
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
        timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
      );
    } catch (e) {
      print('Error parsing date/time: $e');
      return null;
    }
  }

  String get formattedTime {
    if (time == null) return '';
    final timeParts = time!.split(':');
    return '${timeParts[0]}:${timeParts[1]}';
  }

  String get formattedDate {
    if (date == null) return '';
    final dateParts = date!.split('-');
    return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
  }
}

@JsonSerializable()
class SeatModel {
  @JsonKey(name: 'seatId')
  final String? seatId;

  @JsonKey(name: 'row')
  final String? row;

  @JsonKey(name: 'number')
  final int? number;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'priceModifier')
  final double? priceModifier;

  @JsonKey(name: 'roomName')
  final String? roomName;

  @JsonKey(ignore: true)
  bool isSelected = false;

  @JsonKey(ignore: true)
  bool isTaken = false;

  SeatModel({
    this.seatId,
    this.row,
    this.number,
    this.type,
    this.priceModifier,
    this.roomName,
    this.isSelected = false,
    this.isTaken = false,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) => _$SeatModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeatModelToJson(this);

  // get seat label (vi' du : "A1", "B3" , "C4")
  String get label => '${row ?? ''}${number ?? ''}';

  SeatModel copyWith({
    String? seatId,
    String? row,
    int? number,
    String? type,
    double? priceModifier,
    String? roomName,
    bool? isSelected,
    bool? isTaken,
  }) {
    return SeatModel(
      seatId: seatId ?? this.seatId,
      row: row ?? this.row,
      number: number ?? this.number,
      type: type ?? this.type,
      priceModifier: priceModifier ?? this.priceModifier,
      roomName: roomName ?? this.roomName,
      isSelected: isSelected ?? this.isSelected,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}

