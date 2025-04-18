
import 'package:json_annotation/json_annotation.dart';
part 'order_request.g.dart';

@JsonSerializable()
class OrderRequest {
  final String userId;
  @JsonKey(name: 'orderDetails')
  final List<OrderDetails> orderDetailsList;


 OrderRequest({
  required this.userId,
   required this.orderDetailsList,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) => _$OrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

@JsonSerializable()
class OrderDetails {
  final List<TicketRequest> ticketRequests;
  final List<Extra> extras;

  OrderDetails({
    required this.ticketRequests,
    required this.extras
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => _$OrderDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}

@JsonSerializable()
class TicketRequest {
  final String showtimeId;
  final String seatId;

  TicketRequest({
    required this.showtimeId,
    required this.seatId,
  });

  factory TicketRequest.fromJson(Map<String, dynamic> json) => _$TicketRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TicketRequestToJson(this);
}

@JsonSerializable()
class Extra {
  final String id;
  final int quantity;

  Extra({
    required this.id,
    required this.quantity,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraToJson(this);
}