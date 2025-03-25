import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/models/movie.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketMovieScreen extends StatelessWidget {
  final Movie movie;
  const TicketMovieScreen({super.key, required this.movie});

  String buildQrData(Movie movie) {
    final Map<String, dynamic> data = {
      'title': movie.title,
      'releaseDate': movie.releaseDate,
      'duration': movie.duration,
      'rating': movie.rating,
      'genres': movie.genres,
    };
    return jsonEncode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: tdRed,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: tdWhite, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'My Tickets',
                        style: TextStyle(
                          color: tdWhite,
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

            Expanded(
              child: Center(
                child: ClipPath(
                  clipper: TicketClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 700,
                    color: Colors.deepOrange,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 370,
                          child: Stack(
                            children: [
                              // 1) Ảnh poster
                              Positioned.fill(
                                child: Image.network(
                                  movie.posterUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // 2) Gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        tdRedLight.withOpacity(0.2),
                                        tdOrangeRed.withOpacity(0.7),
                                        Colors.deepOrange,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Đường gạch đứt (dashed line)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CustomPaint(
                            painter: DashedLinePainter(),
                            child: const SizedBox(
                              height: 1,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        // Thông tin ngày + giờ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: const [
                                Text(
                                  '18',
                                  style: TextStyle(
                                    color: tdWhite70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Mon',
                                  style: TextStyle(
                                    color: tdWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: const [
                                Icon(
                                  Icons.access_time,
                                  color: tdWhite70,
                                  size: 20,
                                ),
                                Text(
                                  '14:31',
                                  style: TextStyle(
                                    color: tdWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Hall, Row, Seats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Hall',
                                  style: TextStyle(
                                    color: tdWhite54,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '02',
                                  style: TextStyle(
                                    color: tdWhite,
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
                                    color: tdWhite54,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '04',
                                  style: TextStyle(
                                    color: tdWhite,
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
                                    color: tdWhite54,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '23,24',
                                  style: TextStyle(
                                    color: tdWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // QR Code (demo)
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: Center(
                            child: QrImageView(
                              data: buildQrData(movie),
                              version: QrVersions.auto,
                              size: 200.0,
                              gapless: false,
                              foregroundColor: tdWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CLIPPER TẠO 2 KHUYẾT TRÒN Ở GIỮA 2 BÊN

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double cornerRadius = 16.0;
    final double notchCenter = size.height * 0.55;
    const double notchRadius = 24.0;

    final path = Path();

    // Bắt đầu từ góc trên bên trái sau khi bo góc (vị trí bắt đầu = (cornerRadius, 0))
    path.moveTo(cornerRadius, 0);

    path.lineTo(size.width - cornerRadius, 0);
    // Góc trên bên phải: vẽ cung bo góc
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(size.width, notchCenter - notchRadius);
    path.arcToPoint(
      Offset(size.width, notchCenter + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height - cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(cornerRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(0, notchCenter + notchRadius);
    path.arcToPoint(
      Offset(0, notchCenter - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}

/// VẼ ĐƯỜNG GẠCH ĐỨT
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black38
          ..strokeWidth = 1;

    // Chiều rộng nét đứt + khoảng trống
    const dashWidth = 6.0;
    const dashSpace = 7.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}
