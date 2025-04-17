import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/ticket_history/bloc/ticket_event.dart';
import 'package:movie_booking_ticket/features/ticket_history/bloc/ticket_state.dart';
import 'package:movie_booking_ticket/features/ticket_history/controllers/ticket_controller.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketController _ticketController;

  TicketBloc({TicketController? ticketController})
    : _ticketController = ticketController ?? TicketController(),
      super(TicketState()) {
    on<FetchTicketHistoryEvent>(_onFetchTicketHistory);
  }

  Future<void> _onFetchTicketHistory(
    FetchTicketHistoryEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(state.copyWith(status: TicketStateStatus.loading));

    try {
      final List<MovieTicketModel> tickets = await _ticketController
          .fetchMovieTicketHistory(event.userId);
      emit(state.copyWith(status: TicketStateStatus.success, orders: tickets));
    } catch (e) {
      emit(
        state.copyWith(
          status: TicketStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
