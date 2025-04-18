// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_callback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCallbackResponse _$PaymentCallbackResponseFromJson(
  Map<String, dynamic> json,
) => PaymentCallbackResponse(
  orderId: json['orderId'] as String,
  status: json['status'] as String,
  message: json['message'] as String,
  ticketData:
      json['ticketData'] == null
          ? null
          : TicketData.fromJson(json['ticketData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentCallbackResponseToJson(
  PaymentCallbackResponse instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'status': instance.status,
  'message': instance.message,
  'ticketData': instance.ticketData,
};

TicketData _$TicketDataFromJson(Map<String, dynamic> json) => TicketData(
  ticketId: json['ticketId'] as String,
  movieTitle: json['movieTitle'] as String,
  roomName: json['roomName'] as String,
  date: json['date'] as String,
  time: json['time'] as String,
  seatNumbers:
      (json['seatNumbers'] as List<dynamic>).map((e) => e as String).toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  qrCode: json['qrCode'] as String,
);

Map<String, dynamic> _$TicketDataToJson(TicketData instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'movieTitle': instance.movieTitle,
      'roomName': instance.roomName,
      'date': instance.date,
      'time': instance.time,
      'seatNumbers': instance.seatNumbers,
      'totalAmount': instance.totalAmount,
      'qrCode': instance.qrCode,
    };
