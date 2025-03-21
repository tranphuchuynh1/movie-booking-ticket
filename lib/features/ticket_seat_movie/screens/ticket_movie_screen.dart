import 'package:flutter/material.dart';

class TicketMovieScreen extends StatelessWidget {
  const TicketMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'My Tickets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // (Ticket)
            Expanded(child: Center(child: TicketWidget())),

            Container(
              height: 60,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.event_seat_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),

                  // Biểu tượng vé
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.confirmation_num_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget vé phim
class TicketWidget extends StatelessWidget {
  const TicketWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // tickets width ~80%
    final double ticketWidth = MediaQuery.of(context).size.width * 0.8;

    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        width: ticketWidth,
        color: Colors.orange, // Nền vé màu cam
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/maleficent.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //  (dashed line)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomPaint(
                painter: DashedLinePainter(),
                child: SizedBox(width: ticketWidth, height: 1),
              ),
            ),

            // 3) info film/seat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'John Wick Chapter 4',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text(
                            '18',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Mon',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                      const Text(
                        '|',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      Column(
                        children: const [
                          Text(
                            '14:30',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Time',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 8),

                  // Hall, Row, Seats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Hall',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '02',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Row',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '04',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Seats',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '23,24',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tạo hình cắt (clip) cho vé: hai nửa hình tròn ở 2 bên
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 20.0;
    final path = Path();

    // Bắt đầu từ góc trái trên
    path.moveTo(0, 0);
    // Kẻ đường thẳng tới góc phải trên
    path.lineTo(size.width, 0);

    // Kẻ xuống tới (size.height * 0.3 - radius)
    path.lineTo(size.width, size.height * 0.3 - radius);

    // Vẽ nửa hình tròn bên phải
    path.arcToPoint(
      Offset(size.width, size.height * 0.3 + radius),
      radius: const Radius.circular(radius),
      clockwise: false,
    );

    // Kẻ thẳng xuống góc phải dưới
    path.lineTo(size.width, size.height);

    // Kẻ sang góc trái dưới
    path.lineTo(0, size.height);

    // Lên tới (size.height * 0.3 + radius)
    path.lineTo(0, size.height * 0.3 + radius);

    // Vẽ nửa hình tròn bên trái
    path.arcToPoint(
      Offset(0, size.height * 0.3 - radius),
      radius: const Radius.circular(radius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}

// (dashed line)
class DashedLinePainter extends CustomPainter {
  @override
  /*************  ✨ Codeium Command ⭐  *************/
  /// Vẽ d  ng line kh ng li n t c (dashed line) ng ng
  /// - [dashWidth]: Chi u r ng c a m t d  ng line
  /// - [dashSpace]: Kho ng c ch gi a 2 d  ng line
  /// - [startX]: T o do x u t phia tr u c ti p theo c a d  ng line
  /// V  d : [0, 0, 0, 5, 10, 15, 20, ...]
  /******  0c64527c-6a57-46ac-af80-5bbbd24ccbf3  *******/
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;

    // Vẽ liên tiếp những đoạn line dài dashWidth, cách nhau dashSpace
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}
