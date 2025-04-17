import 'package:movie_booking_ticket/core/models/movie_model.dart';

enum TicketStateStatus { initial, loading, success, error }

class TicketState {
  final TicketStateStatus status;
  final List<MovieTicketModel>? orders;
  final String? errorMessage;

  TicketState({
    this.status = TicketStateStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  TicketState copyWith({
    TicketStateStatus? status,
    List<MovieTicketModel>? orders,
    String? errorMessage,
  }) {
    return TicketState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
