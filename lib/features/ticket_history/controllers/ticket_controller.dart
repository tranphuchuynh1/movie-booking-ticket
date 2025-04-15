import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';
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
        throw Exception(response.message ?? response.error ?? "Unknown error");
      }
    } catch (e) {
      throw Exception("Failed to fetch movie ticket history: $e");
    }
  }
}
