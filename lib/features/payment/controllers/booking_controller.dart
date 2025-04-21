import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/features/payment/controllers/booking_service.dart';

import '../../../core/models/payment/order_request.dart';
import '../../../core/models/payment/order_response.dart';
import '../../../core/models/payment/payment_request.dart';


class BookingController {
  final BookingService _bookingService;

  BookingController({Dio? dio})
      : _bookingService = BookingService(dio ?? DioClient.instance);

  Future<OrderResponse> createOrder(String userId, List<TicketRequest> tickets, List<Extra> extras) async {
    try {
      // Tạo một đối tượng OrderDetails
      final orderDetails = OrderDetails(
        ticketRequests: tickets,
        extras: extras,
      );

      // Tạo OrderRequest với orderDetailsList là một mảng chứa orderDetails
      final orderRequest = OrderRequest(
        userId: userId,
        orderDetailsList: [orderDetails], // Đặt trong mảng
      );

      print("Request data: ${jsonEncode(orderRequest.toJson())}");
      return await _bookingService.createOrder(orderRequest);
    } catch (e) {
      print("Error creating order: $e");
      throw Exception('Không thể tạo đơn hàng: ${e.toString()}');
    }
  }

  Future<String> getPaymentUrl(String orderId, int amount) async {
    try {
      final paymentRequest = PaymentRequest(
        orderId: orderId,
        amount: amount,
        returnUrl: 'https://minhtue-001-site1.ktempurl.com/api/payments/payment-callback',
      );

      final response = await _bookingService.getPaymentUrl(paymentRequest);
      return response.url;
    } catch (e) {
      print("Error getting payment URL: $e");
      throw Exception('Failed to get payment URL: ${e.toString()}');
    }
  }
}