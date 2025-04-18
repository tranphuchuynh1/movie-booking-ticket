import 'package:json_annotation/json_annotation.dart';

part 'payment_callback_response.g.dart';

@JsonSerializable()
class PaymentCallbackResponse {
  final String orderId;
  final String status;
  final String message;
  final TicketData? ticketData;

  PaymentCallbackResponse({
    required this.orderId,
    required this.status,
    required this.message,
    this.ticketData,
  });

  factory PaymentCallbackResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentCallbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCallbackResponseToJson(this);
}

@JsonSerializable()
class TicketData {
  final String ticketId;
  final String movieTitle;
  final String roomName;
  final String date;
  final String time;
  final List<String> seatNumbers;
  final double totalAmount;
  final String qrCode;

  TicketData({
    required this.ticketId,
    required this.movieTitle,
    required this.roomName,
    required this.date,
    required this.time,
    required this.seatNumbers,
    required this.totalAmount,
    required this.qrCode,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) => _$TicketDataFromJson(json);
  Map<String, dynamic> toJson() => _$TicketDataToJson(this);
}