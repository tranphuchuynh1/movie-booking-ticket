// lib/features/my_ticket_movie/bloc/ticket_event.dart
part of 'ticket_bloc.dart';

abstract class TicketEvent {}

class FetchTicketEvent extends TicketEvent {
  final String orderId;

  FetchTicketEvent(this.orderId);
}

class FetchTicketDetailsEvent extends TicketEvent {
  final String userId;
  final String movieId;
  FetchTicketDetailsEvent({required this.userId, required this.movieId});
}
