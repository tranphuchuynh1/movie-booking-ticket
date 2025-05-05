import 'package:dio/dio.dart';
import 'package:movie_booking_ticket/core/constants/constants.dart';
import 'package:movie_booking_ticket/core/models/base_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/models/ticket_model.dart';

part 'ticket_movie_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TicketService {
  factory TicketService(Dio dio, {String baseUrl}) = _TicketService;

  @GET('/tickets/{orderId}')
  Future<BaseResponse<List<TicketModel>>> getTicketsByOrderId(
    @Path('orderId') String orderId,
  );
  @GET(ApiConstants.myTicketEndpoint)
  Future<BaseResponse<List<TicketModel>>> getMovieTicketDetails(
    @Path("userId") String userId,
    @Path("movieId") String movieId,
  );
}
