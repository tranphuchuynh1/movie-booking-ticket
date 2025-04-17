abstract class TicketEvent {}

class FetchTicketHistoryEvent extends TicketEvent {
  final String userId;

  FetchTicketHistoryEvent(this.userId);
}
