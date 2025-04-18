import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/ticket_model.dart';
import 'package:movie_booking_ticket/features/my_ticket_movie/controllers/ticket_movie_service.dart';

class TicketMovieController {
  final TicketService _ticketService;

  TicketMovieController({Dio? dio})
      : _ticketService = TicketService(dio ?? Dio());

  Future<List<TicketModel>> getTicketsByOrderId(String orderId) async {
    try {
      final response = await _ticketService.getTicketsByOrderId(orderId);

      // Check if the response is successful and contains data
      if (response.success == true && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.error ?? 'Failed to fetch tickets');
      }
    } catch (e) {
      throw Exception('Error fetching tickets: ${e.toString()}');
    }
  }
}