part of 'select_seat_movie_bloc.dart';

abstract class SelectSeatEvent {}

class FetchShowtimesEvent extends SelectSeatEvent {
  final String movieId;

  FetchShowtimesEvent(this.movieId);
}

class FetchSeatsEvent extends SelectSeatEvent {
  final String showtimeId;

  FetchSeatsEvent(this.showtimeId);
}

class FetchBookedSeatsEvent extends SelectSeatEvent {
  final String showtimeId;

  FetchBookedSeatsEvent(this.showtimeId);
}

class SelectDateEvent extends SelectSeatEvent {
  final String date;

  SelectDateEvent(this.date);
}

class SelectTimeEvent extends SelectSeatEvent {
  final String showtimeId;

  SelectTimeEvent(this.showtimeId);
}

class ToggleSeatEvent extends SelectSeatEvent {
  final String seatId;

  ToggleSeatEvent(this.seatId);
}