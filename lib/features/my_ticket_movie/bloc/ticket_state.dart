// lib/features/my_ticket_movie/bloc/ticket_state.dart
part of 'ticket_bloc.dart';

enum TicketStatus { initial, loading, success, error }

class TicketState {
  final TicketStatus status;
  final List<TicketModel> tickets;
  final String? errorMessage;

  TicketState({
    this.status = TicketStatus.initial,
    this.tickets = const [],
    this.errorMessage,
  });

  TicketState copyWith({
    TicketStatus? status,
    List<TicketModel>? tickets,
    String? errorMessage,
  }) {
    return TicketState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}