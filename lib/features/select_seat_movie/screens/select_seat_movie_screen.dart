import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie.dart';
import 'package:movie_booking_ticket/theme.dart';

class SelectSeatMovieScreen extends StatefulWidget {
  final Movie movie;

  const SelectSeatMovieScreen({super.key, required this.movie});
  @override
  State<SelectSeatMovieScreen> createState() => SelectSeatMovieScreenState();
}

class SelectSeatMovieScreenState extends State<SelectSeatMovieScreen> {
  // 0 = Available (trắng), 1 = Selected (cam), 2 = Taken (xám)
  List<List<int>> seatMatrix = [
    [2, 0, 0],
    [0, 0, 0, 2, 0],
    [0, 0, 0, 0, 2, 2, 0],
    [0, 0, 0, 2, 0, 0, 2],
    [0, 0, 2, 2, 0, 0, 2, 2, 0],
    [0, 0, 0, 2, 0, 0, 2, 0, 0],
    [0, 0, 0, 0, 2, 2, 0],
    [2, 0, 0, 2, 0, 0, 2],
    [0, 0, 0, 2, 0],
    [2, 0, 0],
  ];

  final List<int> selectedSeats = [];

  final double ticketPrice = 15.0;

  void toggleSeat(int row, int col) {
    setState(() {
      // Tính index = row*10 + col (nếu 10 cột)
      int seatIndex = row * seatMatrix[row].length + col;

      // Nếu ghế đang trống => chuyển sang Selected
      if (seatMatrix[row][col] == 0) {
        seatMatrix[row][col] = 1;
        selectedSeats.add(seatIndex);
      }
      // Nếu ghế đang Selected => bỏ chọn
      else if (seatMatrix[row][col] == 1) {
        seatMatrix[row][col] = 0;
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
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.movie.posterUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              height: 250,
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
              height: 200,
              child: Icon(Icons.play_arrow, color: tdWhite54, size: 50),
            ),

            Positioned(
              top: 8,
              left: 8,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: tdRed,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: tdWhite70, size: 15),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),

            Positioned.fill(
              top: 230,
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
                    const SizedBox(height: 20),
                    const Text(
                      "Screen this side",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),

                    //ghế
                    Expanded(
                      child: SingleChildScrollView(
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
                    ),

                    // chọn ngày
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(days.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Price",
                                style: TextStyle(
                                  color: tdWhite70,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "\$${(selectedSeats.length * ticketPrice).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: tdWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Buy Tickets
                          ElevatedButton(
                            onPressed:
                                selectedSeats.isEmpty
                                    ? null
                                    : () {
                                      context.go(
                                        '/ticket',
                                        extra: widget.movie,
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
          ],
        ),
      ),
    );
  }

  //  layout ghế
  Widget _buildSeatLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mỗi row = 1 Row widget, each seat = Container
        Column(
          children: List.generate(seatMatrix.length, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(seatMatrix[row].length, (col) {
                if (seatMatrix[row][col] == -1) {
                  // ẩn ghế -> trả về SizedBox
                  return const SizedBox(width: 24, height: 24);
                } else {
                  Color seatColor;
                  if (seatMatrix[row][col] == 0) {
                    seatColor = tdWhite;
                  } else if (seatMatrix[row][col] == 1) {
                    seatColor = tdRed;
                  } else {
                    seatColor = tdGreyDark;
                  }
                  return GestureDetector(
                    onTap: () => toggleSeat(row, col),
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 7,
                        left: 7,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Icon(Icons.chair, color: seatColor, size: 22),
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
            _seatLegend(tdWhite, "Available"),
            const SizedBox(width: 20),
            _seatLegend(tdGreyDark, "Taken"),
            const SizedBox(width: 20),
            _seatLegend(tdRed, "Selected"),
          ],
        ),
      ],
    );
  }

  Widget _seatLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Icon(Icons.chair_rounded, color: color, size: 20),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: tdWhite70, fontSize: 12)),
      ],
    );
  }

  Widget _buildDayItem({
    required String day,
    required String weekDay,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            weekDay,
            style: TextStyle(
              color: isSelected ? tdRed : Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          // Thanh gạch màu cam khi selected
          if (isSelected) Container(width: 20, height: 2, color: tdRed),
        ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? tdRed : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
