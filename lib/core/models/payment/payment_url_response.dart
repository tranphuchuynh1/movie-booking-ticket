import 'package:json_annotation/json_annotation.dart';

part 'payment_url_response.g.dart';

@JsonSerializable()
class PaymentUrlResponse {
  final String url;

  PaymentUrlResponse({
    required this.url,
  });

  factory PaymentUrlResponse.fromJson(Map<String, dynamic> json) => _$PaymentUrlResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentUrlResponseToJson(this);
}