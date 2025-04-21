import 'package:json_annotation/json_annotation.dart';

part 'payment_request.g.dart';

@JsonSerializable()
class PaymentRequest {
  final String orderId;
  final int amount;
  final String returnUrl;

  PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.returnUrl,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}