import 'package:json_annotation/json_annotation.dart';

part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  final String id;
  final String imageMovie;
  final String hall;
  final String showTimeDate;
  final String showTimeStart;
  final String seatRow;
  final int seatNumber;
  final String qrCode;

  TicketModel({
    required this.id,
    required this.imageMovie,
    required this.hall,
    required this.showTimeDate,
    required this.showTimeStart,
    required this.seatRow,
    required this.seatNumber,
    required this.qrCode,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);
  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}