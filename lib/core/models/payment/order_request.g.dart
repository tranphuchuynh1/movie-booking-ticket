// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) => OrderRequest(
  userId: json['userId'] as String,
  orderDetailsList:
      (json['orderDetails'] as List<dynamic>)
          .map((e) => OrderDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'orderDetails': instance.orderDetailsList,
    };

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
  ticketRequests:
      (json['ticketRequests'] as List<dynamic>)
          .map((e) => TicketRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
  extras:
      (json['extras'] as List<dynamic>)
          .map((e) => Extra.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'ticketRequests': instance.ticketRequests,
      'extras': instance.extras,
    };

TicketRequest _$TicketRequestFromJson(Map<String, dynamic> json) =>
    TicketRequest(
      showtimeId: json['showtimeId'] as String,
      seatId: json['seatId'] as String,
    );

Map<String, dynamic> _$TicketRequestToJson(TicketRequest instance) =>
    <String, dynamic>{
      'showtimeId': instance.showtimeId,
      'seatId': instance.seatId,
    };

Extra _$ExtraFromJson(Map<String, dynamic> json) => Extra(
  id: json['id'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$ExtraToJson(Extra instance) => <String, dynamic>{
  'id': instance.id,
  'quantity': instance.quantity,
};
