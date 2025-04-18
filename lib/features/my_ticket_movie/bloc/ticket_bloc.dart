import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/models/ticket_model.dart';
import 'package:movie_booking_ticket/features/my_ticket_movie/controllers/ticket_movie_controller.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketMovieController _ticketController = TicketMovieController();

  TicketBloc() : super(TicketState()) {
    on<FetchTicketEvent>(_onFetchTicket);
  }

  Future<void> _onFetchTicket(
      FetchTicketEvent event,
      Emitter<TicketState> emit,
      ) async {
    emit(state.copyWith(status: TicketStatus.loading));

    try {
      final tickets = await _ticketController.getTicketsByOrderId(event.orderId);

      if (tickets.isEmpty) {
        emit(state.copyWith(
          status: TicketStatus.error,
          errorMessage: 'Không tìm thấy thông tin vé',
        ));
        return;
      }

      emit(state.copyWith(
        status: TicketStatus.success,
        tickets: tickets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TicketStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}