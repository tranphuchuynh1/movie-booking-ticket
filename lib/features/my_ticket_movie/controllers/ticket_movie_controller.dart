import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';
import 'package:movie_booking_ticket/features/my_ticket_movie/controllers/ticket_movie_service.dart';
import 'package:movie_booking_ticket/core/models/ticket_model.dart';

class TicketMovieController {
  final TicketService _ticketService;

  TicketMovieController({TicketService? service})
    : _ticketService = service ?? TicketService(DioClient.instance);

  Future<void> _attachAuthHeader() async {
    final token = await SaveTokenUserService.getAccessToken();
    if (token != null) {
      DioClient.instance.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<List<TicketModel>> getTicketsByOrderId(String orderId) async {
    await _attachAuthHeader();
    final response = await _ticketService.getTicketsByOrderId(orderId);
    if (response.success == true && response.data != null) {
      return response.data!;
    }
    throw Exception(response.error ?? 'Failed to fetch tickets');
  }

  Future<List<TicketModel>> getTicketsByUserMovie({
    required String userId,
    required String movieId,
  }) async {
    await _attachAuthHeader();
    final response = await _ticketService.getMovieTicketDetails(
      userId,
      movieId,
    );
    if (response.success == true && response.data != null) {
      return response.data!;
    }
    throw Exception(
      response.error ?? response.message ?? 'Failed to fetch movie tickets',
    );
  }
}
