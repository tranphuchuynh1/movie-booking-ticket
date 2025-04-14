import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/theme.dart';

class SelectSeatMovieScreen extends StatefulWidget {
  const SelectSeatMovieScreen({super.key});
  @override
  State<SelectSeatMovieScreen> createState() => SelectSeatMovieScreenState();
}

class SelectSeatMovieScreenState extends State<SelectSeatMovieScreen> {
  // 0 = Available (trắng), 1 = Selected (cam), 2 = Taken (xám)
  // 3 = Ghế đôi còn trống
  // 4 = Ghế đôi đã chọn
  // 5 = Ghế đôi đã bán (taken)

  List<List<int>> seatMatrix = [
    [0, 0, 2, 2, 0, 0, 2, 2, 0, 0],
    [0, 0, 0, 2, 0, 0, 2, 0, 0, 0],
    [0, 0, 2, 2, 0, 0, 2, 2, 0, 0],
    [0, 0, 0, 2, 0, 0, 2, 0, 0, 0],
    [0, 0, 2, 2, 0, 0, 2, 2, 0, 0],
    [0, 0, 0, 2, 0, 0, 2, 0, 0, 0],
    [3, 3, 3, 3, 3],
  ];

  final List<int> selectedSeats = [];

  final double ticketPrice = 15.0;

  void toggleSeat(int row, int col) {
    setState(() {
      // index = row*10 + col ( 10 cột)
      int seatIndex = row * seatMatrix[row].length + col;
      int seatValue = seatMatrix[row][col];

      if (seatValue == 0) {
        seatMatrix[row][col] = 1;
        selectedSeats.add(seatIndex);
      } else if (seatValue == 1) {
        seatMatrix[row][col] = 0;
        selectedSeats.remove(seatIndex);
      }
      // Ghế đôi
      else if (seatValue == 3) {
        seatMatrix[row][col] = 4;
        selectedSeats.add(seatIndex);
      } else if (seatValue == 4) {
        seatMatrix[row][col] = 3;
        selectedSeats.remove(seatIndex);
      }
    });
  }

  int selectedDayIndex = 1; // ví dụ default = ngày 18 (Mon)
  int selectedTimeIndex = 2; // ví dụ default = 14:30

  final List<String> days = List.generate(
    30,
    (index) => (index + 1).toString(),
  );
  final List<String> weekdays = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];
  final List<String> times = [
    "10:30",
    "12:30",
    "14:30",
    "15:30",
    "17:30",
    "19:30",
    "21:30",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdGreyDark,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(''), // Poster img
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

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
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              height: 300,
              child: Icon(Icons.play_arrow, color: tdWhite54, size: 50),
            ),

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Screen this side",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),

                      //ghế
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: _buildSeatLayout(),
                          ),
                        ),
                      ),

                      // chọn ngày
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(days.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 14.0),
                                child: _buildDayItem(
                                  day: days[index],
                                  weekDay: weekdays[index % weekdays.length],
                                  isSelected: selectedDayIndex == index,
                                  onTap: () {
                                    setState(() {
                                      selectedDayIndex = index;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ), // chọn giờ chiếu
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(times.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: _buildTimeItem(
                                  times[index],
                                  isSelected: selectedTimeIndex == index,
                                  onTap: () {
                                    setState(() {
                                      selectedTimeIndex = index;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      // tổng giá + Nút mua vé
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Price",
                                    style: TextStyle(
                                      color: tdWhite70,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "${(selectedSeats.length * ticketPrice).toStringAsFixed(2)} VND",
                                    style: const TextStyle(
                                      color: tdWhite,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Buy Tickets
                            ElevatedButton(
                              onPressed:
                                  selectedSeats.isEmpty
                                      ? null
                                      : () {
                                        context.go(
                                          '/ticket',
                                          extra: 'widget.movie',
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tdRed,
                                disabledBackgroundColor: tdWhite54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 18,
                                ),
                              ),
                              child: const Text(
                                "Buy Tickets",
                                style: TextStyle(fontSize: 18, color: tdWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  layout ghế
  Widget _buildSeatLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;

        final int seatsPerRow =
            seatMatrix.isNotEmpty ? seatMatrix[0].length : 0;
        const double margin = 6.0;

        final double totalMargin = margin * 2 * seatsPerRow;

        // Kích thước tối đa dành cho icon ghế
        final double availableWidthForIcons = totalWidth - totalMargin;
        final double baseIconSize = availableWidthForIcons / seatsPerRow;
        const double doubleSeatMultiplier = 1.5;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mỗi row = 1 Row widget, each seat = Container
            Column(
              children: List.generate(seatMatrix.length, (row) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(seatMatrix[row].length, (col) {
                    int seatValue = seatMatrix[row][col];

                    if (seatMatrix[row][col] == -1) {
                      // ẩn ghế -> trả về SizedBox
                      return const SizedBox(width: 24, height: 24);
                    } else {
                      Color seatColor;
                      if (seatValue == 0 || seatValue == 3) {
                        seatColor = tdWhite;
                      } else if (seatValue == 1 || seatValue == 4) {
                        seatColor = tdRed;
                      } else {
                        seatColor = tdGreyDark;
                      }

                      bool isDoubleSeat =
                          (seatValue == 3 || seatValue == 4 || seatValue == 5);

                      double iconSize =
                          isDoubleSeat
                              ? baseIconSize * doubleSeatMultiplier
                              : baseIconSize;

                      return GestureDetector(
                        onTap: () => toggleSeat(row, col),
                        child: Padding(
                          padding: const EdgeInsets.all(margin),

                          child: Icon(
                            isDoubleSeat
                                ? Icons.weekend_rounded
                                : Icons.chair_rounded,
                            color: seatColor,
                            size: iconSize,
                          ),
                        ),
                      );
                    }
                  }),
                );
              }),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _seatLegend(tdWhite, "  Available"),
                const SizedBox(width: 24),
                _seatLegend(tdGreyDark, "  Taken"),
                const SizedBox(width: 24),
                _seatLegend(tdRed, "  Selected"),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _seatLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Icon(Icons.chair_rounded, color: color, size: 22),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: tdWhite70, fontSize: 14)),
      ],
    );
  }

  Widget _buildDayItem({
    required String day,
    required String weekDay,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weekDay,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(
    String time, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepOrange : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            time,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
