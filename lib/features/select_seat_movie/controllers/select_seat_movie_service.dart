import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/showtime_model.dart';

part 'select_seat_movie_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class BookingService {
  factory BookingService(Dio dio, {String baseUrl}) = _BookingService;

  @GET('${ApiConstants.bookingsEndpoint}/showtimes/{movieId}')
  Future<BaseResponse<List<ShowtimeModel>>> getShowtimes(
      @Path('movieId') String movieId);

  @GET('${ApiConstants.bookingsEndpoint}/seats/{showtimeId}')
  Future<BaseResponse<List<SeatModel>>> getSeats(
      @Path('showtimeId') String showtimeId);

  @GET('${ApiConstants.bookingsEndpoint}/booked-seat/{showtimeId}')
  Future<BaseResponse<List<SeatModel>>> getBookedSeats(
      @Path('showtimeId') String showtimeId);

}