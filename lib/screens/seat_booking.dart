import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/screens/tickets.dart';

class SeatBookingScreen extends StatefulWidget {
  const SeatBookingScreen({super.key});

  @override
  SeatBookingScreenState createState() => SeatBookingScreenState();
}

class SeatBookingScreenState extends State<SeatBookingScreen> {
  List<List<int>> seats = List.generate(
    8,
    (row) => List.generate(10, (col) => 0),
  );

  final List<int> takenSeats = [13, 14, 23, 24, 33, 34, 43, 44];
  final List<int> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    for (var seat in takenSeats) {
      seats[seat ~/ 10][seat % 10] = 2; // 2 = ghế đã đặt
    }
  }

  void selectSeat(int row, int col) {
    setState(() {
      if (seats[row][col] == 0) {
        seats[row][col] = 1; // 1 = ghế đã chọn
        selectedSeats.add(row * 10 + col);
      } else if (seats[row][col] == 1) {
        seats[row][col] = 0; // Bỏ chọn ghế
        selectedSeats.remove(row * 10 + col);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Ảnh header
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange.shade700, Colors.black],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Screen this side',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Ghế ngồi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 80,
              itemBuilder: (context, index) {
                int row = index ~/ 10;
                int col = index % 10;
                Color seatColor;

                if (seats[row][col] == 2) {
                  seatColor = Colors.grey.shade800; // Ghế đã đặt
                } else if (seats[row][col] == 1) {
                  seatColor = Colors.orange; // Ghế được chọn
                } else {
                  seatColor = Colors.white; // Ghế có thể chọn
                }

                return GestureDetector(
                  onTap: () => selectSeat(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),

          // Trạng thái ghế
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              seatLegend(Colors.white, "Available"),
              seatLegend(Colors.grey.shade800, "Taken"),
              seatLegend(Colors.orange, "Selected"),
            ],
          ),

          // Chọn ngày
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dateButton("17", "Sun", false),
                dateButton("18", "Mon", true),
                dateButton("19", "Tue", false),
                dateButton("20", "Wed", false),
                dateButton("21", "Thu", false),
              ],
            ),
          ),

          // Chọn giờ chiếu
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                timeButton("10:30", false),
                timeButton("12:30", false),
                timeButton("14:30", true),
                timeButton("15:30", false),
              ],
            ),
          ),

          // Tổng tiền + nút mua vé
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "\$${(selectedSeats.length * 15.0).toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyTicketsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 100,
                    ),
                  ),
                  child: Text(
                    "Buy Tickets",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seatLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.white70)),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget dateButton(String day, String weekDay, bool isSelected) {
    return Column(
      children: [
        Text(day, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text(
          weekDay,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        if (isSelected) Container(width: 30, height: 3, color: Colors.orange),
      ],
    );
  }

  Widget timeButton(String time, bool isSelected) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
      child: Text(time, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
