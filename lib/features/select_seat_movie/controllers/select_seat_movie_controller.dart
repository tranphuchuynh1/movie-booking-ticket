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

  Future<List<SeatModel>> getBookedSeats(String showtimeId) async {
    try {
      final response = await _bookingService.getBookedSeats(showtimeId);
      return handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load booked seats: ${e.toString()}');
    }
  }
}