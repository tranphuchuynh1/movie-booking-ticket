import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/models/showtime_model.dart';
import 'package:movie_booking_ticket/features/select_seat_movie/controllers/select_seat_movie_service.dart';
import 'package:movie_booking_ticket/utils/util.dart';

class BookingController {
  final BookingService _bookingService;
  final Dio dio;

  BookingController({required this.dio})
      : _bookingService = BookingService(dio);

  Future<List<ShowtimeModel>> getShowtimes(String movieId) async {
    try {
      final response = await _bookingService.getShowtimes(movieId);
      return handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load showtimes: ${e.toString()}');
    }
  }

  Future<List<SeatModel>> getSeats(String showtimeId) async {
    try {
      final response = await _bookingService.getSeats(showtimeId);
      return handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load seats: ${e.toString()}');
    }
  }

  Future<List<String>> getBookedSeats(String showtimeId, {bool forceRefresh = false}) async {
    try {
      Options? options;
      if (forceRefresh) {
        // Thêm timestamp vào query params hoặc headers để tránh cache
        options = Options(
          headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'x-refresh': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );
      }

      final response = await _bookingService.getBookedSeats(showtimeId);
      return response;
    } catch (e) {
      print('Error in getBookedSeats: ${e.toString()}');
      throw Exception('Failed to load booked seats: ${e.toString()}');
    }
  }

}