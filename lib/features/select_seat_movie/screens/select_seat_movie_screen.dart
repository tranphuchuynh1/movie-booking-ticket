import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_ticket/theme.dart';

import '../bloc/select_seat_movie_bloc.dart';

class SelectSeatMovieScreen extends StatefulWidget {
  final String movieId;

  const SelectSeatMovieScreen({super.key, required this.movieId});

  @override
  State<SelectSeatMovieScreen> createState() => _SelectSeatMovieScreenState();
}

class _SelectSeatMovieScreenState extends State<SelectSeatMovieScreen> {
  final SelectSeatBloc _selectSeatBloc = SelectSeatBloc();

  @override
  void initState() {
    super.initState();
    _selectSeatBloc.add(FetchShowtimesEvent(widget.movieId));
    _selectSeatBloc.add(FetchBookedSeatsEvent());
  }

  @override
  void dispose() {
    _selectSeatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _selectSeatBloc,
      child: Scaffold(
        backgroundColor: tdGreyDark,
        body: BlocBuilder<SelectSeatBloc, SelectSeatState>(
          builder: (context, state) {
            if (state.status == SelectSeatStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: tdRed));
            } else if (state.status == SelectSeatStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _selectSeatBloc.add(FetchShowtimesEvent(widget.movieId));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: tdRed),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Main content when data is loaded
            return SafeArea(
              child: Stack(
                children: [
                  // Background image - use the movie image from showtime
                  if (state.selectedShowtime?.movieImage != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(state.selectedShowtime!.movieImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  // Gradient overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    height: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(1),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ),

                  // Main content
                  Positioned.fill(
                    top: 280,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),

                          // Screen indicator
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Seat layout
                          Expanded(
                            child: _buildSeatSection(context, state),
                          ),

                          // Date selection
                          _buildDateSection(context, state),

                          // Time selection
                          _buildTimeSection(context, state),

                          // Total price and Buy button
                          _buildBottomSection(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeatSection(BuildContext context, SelectSeatState state) {
    if (state.seatsStatus == SelectSeatStatus.loading) {
      return const Center(child: CircularProgressIndicator(color: tdRed));
    } else if (state.seatsStatus == SelectSeatStatus.error) {
      return Center(
        child: Text(
          'Error loading seats: ${state.errorMessage}',
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (state.seatMatrix.isEmpty) {
      return const Center(
        child: Text(
          'No seats available for this showtime',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            // Seat matrix
            Column(
              children: state.seatMatrix.map((row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row indicator (A, B, C, D, E, etc)
                      if (row.isNotEmpty && row[0].row != null)
                        SizedBox(
                          width: 24,
                          child: Text(
                            row[0].row!,
                            style: const TextStyle(color: tdWhite70),
                          ),
                        ),

                      // Seats in this row
                      ...row.map((seat) {
                        bool isVipSeat = (seat.type?.toLowerCase().contains('vip') ?? false);
                        bool isDoubleSeat = (seat.type?.toLowerCase().contains('đôi') ?? false);
                        Color seatColor;

                        if (state.bookedSeatIds.contains(seat.seatId)) {
                          seatColor = tdGreyDark;
                          seat.isTaken = true;
                        } else if (seat.isSelected) {
                          seatColor = tdRed;
                        } else {
                          seatColor = isVipSeat ? Colors.amber : tdWhite;
                        }

                        return GestureDetector(
                          onTap: seat.isTaken
                              ? null
                              : () => context.read<SelectSeatBloc>().add(
                              ToggleSeatEvent(seat.seatId ?? '')),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isDoubleSeat ? 60 : 28,
                            height: 28,
                            child: Icon(
                              isDoubleSeat ? Icons.weekend : Icons.chair,
                              color: seatColor,
                              size: isDoubleSeat ? 32 : 24,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Seat legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _seatLegend(tdWhite, "Available"),
                const SizedBox(width: 20),
                _seatLegend(tdGreyDark, "Taken"),
                const SizedBox(width: 20),
                _seatLegend(tdRed, "Selected"),
              ],
            ),

            if (state.seatMatrix.any((row) => row.any((seat) =>
            seat.type?.toLowerCase().contains('vip') ?? false)))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _seatLegend(Colors.amber, "VIP"),
              ),

            // if (state.seatMatrix.any((row) => row.any((seat) =>
            // seat.type?.toLowerCase().contains('đôi') ?? false)))

          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, SelectSeatState state) {
    final dates = state.showtimesByDate.keys.toList();
    final now = DateTime.now();

    final validDates = dates.where((dateStr) {
      try {
        final date = DateTime.parse(dateStr);
        return date.isAfter(now.subtract(const Duration(days: 1)));
      } catch (_) {
        return false;
      }
    }).toList();


    validDates.sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Select Date',
              style: TextStyle(color: tdWhite, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: validDates.length,
              itemBuilder: (context, index) {
                final date = validDates[index];
                final isSelected = date == state.selectedDate;

                // Parse the date to display day of week and day
                DateTime? dateTime;
                try {
                  dateTime = DateTime.parse(date);
                } catch (e) {
                  print('Error parsing date: $e');
                }

                final dayOfWeek = dateTime != null
                    ? DateFormat('E').format(dateTime)
                    : '';
                final dayOfMonth = dateTime != null
                    ? DateFormat('d').format(dateTime)
                    : '';

                return GestureDetector(
                  onTap: () => context.read<SelectSeatBloc>().add(SelectDateEvent(date)),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? tdRed : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayOfMonth,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayOfWeek,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(BuildContext context, SelectSeatState state) {
    final selectedDate = state.selectedDate;

    if (selectedDate == null) {
      return const SizedBox.shrink();
    }

    final showtimesForDate = state.showtimesByDate[selectedDate] ?? [];
    final now = DateTime.now();

    // Filter out past showtimes for today
    final validShowtimes = showtimesForDate.where((showtime) {
      try {
        if (showtime.date == null || showtime.time == null) return false;

        final dateStr = showtime.date!;
        final timeStr = showtime.time!;

        final today = DateTime(now.year, now.month, now.day);
        final showtimeDate = DateTime.parse(dateStr);

        // If not today, include all showtimes
        if (showtimeDate.isAfter(today)) return true;

        // If today, check the time
        final timeParts = timeStr.split(':');
        final showtimeDateTime = DateTime(
          showtimeDate.year,
          showtimeDate.month,
          showtimeDate.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        return showtimeDateTime.isAfter(now);
      } catch (_) {
        return false;
      }
    }).toList();

    if (validShowtimes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Vui lòng chọn ngày chiếu', style: TextStyle(color: tdWhite)),
      );
    }

    // Sort by time
    validShowtimes.sort((a, b) {
      if (a.time == null || b.time == null) return 0;
      return a.time!.compareTo(b.time!);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Select Time',
              style: TextStyle(color: tdWhite, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: validShowtimes.length,
              itemBuilder: (context, index) {
                final showtime = validShowtimes[index];
                final isSelected = showtime.id == state.selectedShowtime?.id;
                final bool isPastTime = false; // You can implement past time check if needed

                return GestureDetector(
                  onTap: isPastTime ? null : () => context.read<SelectSeatBloc>().add(
                      SelectTimeEvent(showtime.id ?? '')),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tdRed
                          : isPastTime
                          ? Colors.grey.shade700
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        showtime.formattedTime,
                        style: TextStyle(
                          color: isPastTime ? Colors.grey : tdWhite,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, SelectSeatState state) {
    final hasSelectedSeats = state.selectedSeats.isNotEmpty;
    final numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(
                  color: tdWhite70,
                  fontSize: 16,
                ),
              ),
              Text(
                numberFormat.format(state.totalPrice),
                style: const TextStyle(
                  color: tdWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasSelectedSeats)
                Text(
                  "${state.selectedSeats.length} seats",
                  style: const TextStyle(
                    color: tdWhite70,
                    fontSize: 14,
                  ),
                ),
            ],
          ),

          // Buy button
          ElevatedButton(
            onPressed: hasSelectedSeats ? () => _processPurchase(context, state) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: tdRed,
              disabledBackgroundColor: tdWhite54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
            ),
            child: const Text(
              "Buy Tickets",
              style: TextStyle(fontSize: 18, color: tdWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seatLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chair, color: color, size: 18),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: tdWhite70, fontSize: 14)),
      ],
    );
  }

  void _processPurchase(BuildContext context, SelectSeatState state) {
    if (state.selectedShowtime == null) return;

    // Create booking data
    final bookingData = {
      'showtimeId': state.selectedShowtime!.id,
      'movieId': state.selectedShowtime!.movieId,
      'date': state.selectedShowtime!.date,
      'time': state.selectedShowtime!.time,
      'roomName': state.selectedShowtime!.roomName,
      'price': state.totalPrice,
      'seats': state.selectedSeats.map((seat) => {
        'seatId': seat.seatId,
        'row': seat.row,
        'number': seat.number,
        'type': seat.type,
      }).toList(),
    };
    context.go('/ticket', extra: bookingData);
  }
}