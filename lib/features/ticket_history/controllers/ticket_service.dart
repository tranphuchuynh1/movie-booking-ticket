import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'ticket_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TicketService {
  factory TicketService(Dio dio, {String baseUrl}) = _TicketService;

  @GET(ApiConstants.movieTicketEndpoint)
  Future<BaseResponse<List<MovieTicketModel>>> getMovieOrdersTicket(
    @Path("userId") String userId,
  );
}
