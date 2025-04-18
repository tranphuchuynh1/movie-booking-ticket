part of 'booking_bloc.dart';

abstract class BookingEvent {}

class CreateOrderEvent extends BookingEvent {
  final String showtimeId;
  final List<SeatModel> selectedSeats;

  CreateOrderEvent({
    required this.showtimeId,
    required this.selectedSeats,
  });
}

class ProcessPaymentEvent extends BookingEvent {}

class CheckPaymentStatusEvent extends BookingEvent {
  final String orderId;

  CheckPaymentStatusEvent(this.orderId);
}