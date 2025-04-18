
import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/payment/order_response.dart';
import 'package:movie_booking_ticket/core/models/payment/payment_callback_response.dart';
import 'package:movie_booking_ticket/core/models/payment/payment_url_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/payment/order_request.dart';
import '../../../core/models/payment/payment_request.dart';

part 'booking_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class BookingService {
  factory BookingService(Dio dio, {String baseUrl}) = _BookingService;
  
  @POST('/orders/create-order')
  Future<OrderResponse> createOrder(@Body() OrderRequest orderRequest);

  @POST('/payments/url')
  Future<PaymentUrlResponse> getPaymentUrl(@Body() PaymentRequest paymentRequest);

  @GET('/payments/payment-callback')
  Future<PaymentCallbackResponse> checkPaymentStatus(@Query('orderId') String orderId);

  @POST('/payments/url')
  Future<dynamic> getPaymentUrlDynamic(@Body() PaymentRequest paymentRequest);

}