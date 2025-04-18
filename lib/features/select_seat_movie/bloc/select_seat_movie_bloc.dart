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

      // nhóm giờ chiếu theo ngày để hiển thị dễ dàng hơn
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

      // chọn ngày và giờ đầu tiên theo mặc định
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
      final bookedSeatIds = await _bookingController.getBookedSeats(event.showtimeId);

      print('Fetched booked seat IDs: $bookedSeatIds');

      // update state với danh sách ghế đã đặt
      emit(state.copyWith(
        bookedSeatIds: bookedSeatIds,
      ));

      // đảm bảo không có ghế đã đặt nào được chọn
      if (state.selectedSeats.any((seat) => bookedSeatIds.contains(seat.seatId))) {
        final updatedSelectedSeats = state.selectedSeats
            .where((seat) => !bookedSeatIds.contains(seat.seatId))
            .toList();

        emit(state.copyWith(
          selectedSeats: updatedSelectedSeats,
        ));
      }
    } catch (e) {
      print('Error fetching booked seats: ${e.toString()}');
    }
  }


  Future<void> _onSelectDate(
      SelectDateEvent event,
      Emitter<SelectSeatState> emit,
      ) async {
    // Cập nhật ngày đã chọn
    emit(state.copyWith(
      selectedDate: event.date,
      selectedShowtime: null,
      selectedSeats: const [],
    ));

    // Lấy các suất chiếu cho ngày đã chọn
    final showtimesForDate = state.showtimesByDate[event.date] ?? [];
    if (showtimesForDate.isEmpty) return;

    // Sắp xếp theo thời gian
    showtimesForDate.sort((a, b) {
      if (a.time == null || b.time == null) return 0;
      return a.time!.compareTo(b.time!);
    });

    // Lọc suất chiếu còn hiệu lực
    final now = DateTime.now();
    final validShowtimes = showtimesForDate.where((showtime) {
      try {
        if (showtime.date == null || showtime.time == null) return false;

        final dateTime = DateTime.parse(showtime.date!);
        final timeParts = showtime.time!.split(':');

        final showtimeDateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        return showtimeDateTime.isAfter(now);
      } catch (_) {
        return false;
      }
    }).toList();

    // Chọn suất chiếu còn hiệu lực đầu tiên hoặc suất đầu tiên nếu không còn suất nào hiệu lực
    final selectedShowtime = validShowtimes.isNotEmpty
        ? validShowtimes.first
        : showtimesForDate.first;

    if (selectedShowtime.id != null) {
      emit(state.copyWith(selectedShowtime: selectedShowtime));
      add(FetchBookedSeatsEvent(selectedShowtime.id!));
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

      // Kiểm tra xem ghế đã được đặt chưa
      if (!state.bookedSeatIds.contains(seat.seatId)) {
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

  // Phương pháp trợ giúp để tạo ma trận chỗ ngồi cho UI
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