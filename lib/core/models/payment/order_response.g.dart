// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
    };
