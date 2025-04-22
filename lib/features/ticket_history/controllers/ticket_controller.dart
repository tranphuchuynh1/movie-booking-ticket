import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/ticket_history/controllers/ticket_service.dart';

class TicketController {
  final TicketService _ticketService;

  TicketController({Dio? dio})
    : _ticketService = TicketService(dio ?? DioClient.instance);

  Future<List<MovieTicketModel>> fetchMovieTicketHistory(String userId) async {
    try {
      final BaseResponse<List<MovieTicketModel>> response =
      (await _ticketService.getMovieOrdersTicket(userId))
      as BaseResponse<List<MovieTicketModel>>;
      if (response.success == true && response.data != null) {
        return response.data!;
      } else {
        // Trả về danh sách rỗng thay vì throw exception
        debugPrint("No tickets found or error: ${response.message ?? response.error}");
        return [];
      }
    } catch (e) {
      debugPrint("Failed to fetch movie ticket history: $e");
      // Trả về danh sách rỗng thay vì throw exception
      return [];
    }
  }
}
