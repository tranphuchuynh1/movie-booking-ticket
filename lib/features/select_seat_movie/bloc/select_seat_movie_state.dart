part of 'select_seat_movie_bloc.dart';

enum SelectSeatStatus { initial, loading, success, error }

class SelectSeatState {
  final SelectSeatStatus status;
  final SelectSeatStatus seatsStatus;
  final List<ShowtimeModel> showtimes;
  final Map<String, List<ShowtimeModel>> showtimesByDate;
  final List<SeatModel> seats;
  final List<List<SeatModel>> seatMatrix;
  final List<SeatModel> selectedSeats;
  final String? selectedDate;
  final ShowtimeModel? selectedShowtime;
  final String? errorMessage;
  final List<String> bookedSeatIds;

  SelectSeatState({
    this.status = SelectSeatStatus.initial,
    this.seatsStatus = SelectSeatStatus.initial,
    this.showtimes = const [],
    this.showtimesByDate = const {},
    this.seats = const [],
    this.seatMatrix = const [],
    this.selectedSeats = const [],
    this.selectedDate,
    this.selectedShowtime,
    this.errorMessage,
    this.bookedSeatIds = const [],
  });

  double get totalPrice {
    if (selectedShowtime == null) return 0;

    double basePrice = selectedShowtime!.price ?? 0;
    double total = 0;

    for (var seat in selectedSeats) {
      double modifier = seat.priceModifier ?? 1.0;
      total += basePrice * modifier;
    }

    return total;
  }

  SelectSeatState copyWith({
    SelectSeatStatus? status,
    SelectSeatStatus? seatsStatus,
    List<ShowtimeModel>? showtimes,
    Map<String, List<ShowtimeModel>>? showtimesByDate,
    List<SeatModel>? seats,
    List<List<SeatModel>>? seatMatrix,
    List<SeatModel>? selectedSeats,
    String? selectedDate,
    ShowtimeModel? selectedShowtime,
    String? errorMessage,
    List<String>? bookedSeatIds,
  }) {
    return SelectSeatState(
      status: status ?? this.status,
      seatsStatus: seatsStatus ?? this.seatsStatus,
      showtimes: showtimes ?? this.showtimes,
      showtimesByDate: showtimesByDate ?? this.showtimesByDate,
      seats: seats ?? this.seats,
      seatMatrix: seatMatrix ?? this.seatMatrix,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedShowtime: selectedShowtime ?? this.selectedShowtime,
      errorMessage: errorMessage ?? this.errorMessage,
      bookedSeatIds: bookedSeatIds ?? this.bookedSeatIds,
    );
  }
}