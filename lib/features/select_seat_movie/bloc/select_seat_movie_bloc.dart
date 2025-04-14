import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/core/models/showtime_model.dart';
import 'package:movie_booking_ticket/features/select_seat_movie/controllers/select_seat_movie_controller.dart';

part 'select_seat_movie_event.dart';
part 'select_seat_movie_state.dart';

class SelectSeatBloc extends Bloc<SelectSeatEvent, SelectSeatState> {
  final BookingController _bookingController = BookingController(dio: DioClient.instance);

  SelectSeatBloc() : super(SelectSeatState()) {
    on<FetchShowtimesEvent>(_onFetchShowtimes);
    on<FetchSeatsEvent>(_onFetchSeats);
    on<FetchBookedSeatsEvent>(_onFetchBookedSeats);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeEvent>(_onSelectTime);
    on<ToggleSeatEvent>(_onToggleSeat);
  }

  Future<void> _onFetchShowtimes(
      FetchShowtimesEvent event,
      Emitter<SelectSeatState> emit,
      ) async {
    emit(state.copyWith(status: SelectSeatStatus.loading));

    try {
      final showtimes = await _bookingController.getShowtimes(event.movieId);

      // group showtimes by date for easier display
      final Map<String, List<ShowtimeModel>> showtimesByDate = {};

      for (var showtime in showtimes) {
        if (showtime.date != null) {
          final date = showtime.date!;
          if (!showtimesByDate.containsKey(date)) {
            showtimesByDate[date] = [];
          }
          showtimesByDate[date]!.add(showtime);
        }
      }

      // select the first date and time by default if available
      String? selectedDate;
      ShowtimeModel? selectedShowtime;

      if (showtimesByDate.isNotEmpty) {
        selectedDate = showtimesByDate.keys.first;
        if (showtimesByDate[selectedDate]!.isNotEmpty) {
          selectedShowtime = showtimesByDate[selectedDate]!.first;
        }
      }

      emit(state.copyWith(
        status: SelectSeatStatus.success,
        showtimes: showtimes,
        showtimesByDate: showtimesByDate,
        selectedDate: selectedDate,
        selectedShowtime: selectedShowtime,
        errorMessage: null,
      ));

      // fetch seats if we have a selected showtime
      if (selectedShowtime != null && selectedShowtime.id != null) {
        add(FetchSeatsEvent(selectedShowtime.id!));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SelectSeatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchSeats(
      FetchSeatsEvent event,
      Emitter<SelectSeatState> emit,
      ) async {
    emit(state.copyWith(seatsStatus: SelectSeatStatus.loading));

    try {
      final seats = await _bookingController.getSeats(event.showtimeId);

      // create a seat matrix for better UI display
      final seatMatrix = _createSeatMatrix(seats);

      emit(state.copyWith(
        seatsStatus: SelectSeatStatus.success,
        seats: seats,
        seatMatrix: seatMatrix,
        selectedSeats: [],
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        seatsStatus: SelectSeatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchBookedSeats(
      FetchBookedSeatsEvent event,
      Emitter<SelectSeatState> emit,
      ) async {
    try {
      final bookedSeats = await _bookingController.getBookedSeats(
          state.selectedShowtime?.id ?? '');

      // -> Extract the seatIds
      final bookedSeatIds = bookedSeats.map((seat) => seat.seatId ?? '').toList();

      emit(state.copyWith(
        bookedSeatIds: bookedSeatIds,
      ));
    } catch (e) {
      // Just log the error, don't change state
      print('Error fetching booked seats: ${e.toString()}');
    }
  }

  void _onSelectDate(
      SelectDateEvent event,
      Emitter<SelectSeatState> emit,
      ) {
    // Get the showtimes for this date
    final showtimesForDate = state.showtimesByDate[event.date] ?? [];

    // Select the first time slot by default
    final selectedShowtime = showtimesForDate.isNotEmpty ? showtimesForDate.first : null;

    emit(state.copyWith(
      selectedDate: event.date,
      selectedShowtime: selectedShowtime,
      selectedSeats: [],
    ));

    // Fetch seats if we have a selected showtime
    if (selectedShowtime != null && selectedShowtime.id != null) {
      add(FetchSeatsEvent(selectedShowtime.id!));
    }
  }

  void _onSelectTime(
      SelectTimeEvent event,
      Emitter<SelectSeatState> emit,
      ) {
    // Find the showtime with this id
    final selectedShowtime = state.showtimes.firstWhere(
          (showtime) => showtime.id == event.showtimeId,
      orElse: () => state.selectedShowtime ?? ShowtimeModel(),
    );

    emit(state.copyWith(
      selectedShowtime: selectedShowtime,
      selectedSeats: [],
    ));

    // Fetch seats for this showtime
    if (selectedShowtime.id != null) {
      add(FetchSeatsEvent(selectedShowtime.id!));
    }
  }

  void _onToggleSeat(
      ToggleSeatEvent event,
      Emitter<SelectSeatState> emit,
      ) {
    final updatedSeats = List<SeatModel>.from(state.seats);
    final seatIndex = updatedSeats.indexWhere((seat) => seat.seatId == event.seatId);

    if (seatIndex != -1) {
      final seat = updatedSeats[seatIndex];
      if (!seat.isTaken) {
        updatedSeats[seatIndex] = seat.copyWith(
          isSelected: !seat.isSelected,
        );
      }
    }

    final selectedSeats = updatedSeats.where((seat) => seat.isSelected).toList();

    // Update the seat matrix
    final seatMatrix = _createSeatMatrix(updatedSeats);

    emit(state.copyWith(
      seats: updatedSeats,
      selectedSeats: selectedSeats,
      seatMatrix: seatMatrix,
    ));
  }

  // Helper method to create a seat matrix for the UI
  List<List<SeatModel>> _createSeatMatrix(List<SeatModel> seats) {
    if (seats.isEmpty) return [];

    // Get all unique rows
    final rows = seats.map((seat) => seat.row).toSet().toList()
      ..sort((a, b) => a?.compareTo(b ?? '') ?? 0);

    // Create a matrix
    final matrix = <List<SeatModel>>[];

    for (var row in rows) {
      if (row == null) continue;

      // Get all seats in this row
      final rowSeats = seats
          .where((seat) => seat.row == row)
          .toList()
        ..sort((a, b) => (a.number ?? 0).compareTo(b.number ?? 0));

      matrix.add(rowSeats);
    }

    return matrix;
  }
}