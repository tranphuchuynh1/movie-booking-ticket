import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_ticket/features/my_ticket_movie/bloc/ticket_bloc.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/models/ticket_model.dart';

class TicketMovieScreen extends StatelessWidget {
  final String? orderId;
  final String? userId;
  final String? movieId;

  const TicketMovieScreen({Key? key, this.orderId, this.userId, this.movieId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketBloc>(
      create: (context) {
        final bloc = TicketBloc();
        // Luồng 1: nếu có orderId thì fetch theo order
        if (orderId != null) {
          bloc.add(FetchTicketEvent(orderId!));
        }
        // Luồng 2: nếu có userId và movieId thì fetch theo phim
        else if (userId != null && movieId != null) {
          bloc.add(FetchTicketDetailsEvent(userId: userId!, movieId: movieId!));
        }
        return bloc;
      },
      child: _TicketMovieView(),
    );
  }
}

class _TicketMovieView extends StatefulWidget {
  @override
  State<_TicketMovieView> createState() => _TicketMovieViewState();
}

class _TicketMovieViewState extends State<_TicketMovieView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state.status == TicketStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: tdRed));
          } else if (state.status == TicketStatus.error) {
            // Hiển thị errorr
            return _buildErrorView(state.errorMessage);
          } else if (state.status == TicketStatus.success &&
              state.tickets.isNotEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  // PageView cho phép lướt qua lại giữa các vé
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.tickets.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildTicket(state.tickets[index]);
                      },
                    ),
                  ),

                  // Thêm indicators nếu có nhiều vé
                  if (state.tickets.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          state.tickets.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  index == _currentPage ? tdRed : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Hiển thị số lượng vé và vé hiện tại
                  if (state.tickets.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_currentPage + 1}/${state.tickets.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
                context.go('/home');
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Vé của tôi',
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
    );
  }

  Widget _buildTicket(TicketModel ticket) {
    return Center(
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.75,
          color: Colors.deepOrange,
          child: Column(
            children: [
              // Ảnh poster
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        ticket.imageMovie,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade800,
                            child: const Icon(
                              Icons.movie,
                              size: 100,
                              color: Colors.white54,
                            ),
                          );
                        },
                      ),
                    ),
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
              const SizedBox(height: 5),

              // Đường gạch đứt
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomPaint(
                  painter: DashedLinePainter(),
                  child: const SizedBox(height: 1, width: double.infinity),
                ),
              ),

              // Ngày và giờ
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        _formatDay(ticket.showTimeDate),
                        style: const TextStyle(
                          color: tdWhite70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDayOfWeek(ticket.showTimeDate),
                        style: const TextStyle(color: tdWhite, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Icon(Icons.access_time, color: tdWhite70, size: 20),
                      Text(
                        _formatTime(ticket.showTimeStart),
                        style: const TextStyle(color: tdWhite, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Phòng - Hàng - Ghế
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Phòng',
                        style: TextStyle(color: tdWhite54, fontSize: 14),
                      ),
                      Text(
                        ticket.hall,
                        style: const TextStyle(
                          color: tdWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Hàng',
                        style: TextStyle(color: tdWhite54, fontSize: 14),
                      ),
                      Text(
                        ticket.seatRow,
                        style: const TextStyle(
                          color: tdWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Ghế',
                        style: TextStyle(color: tdWhite54, fontSize: 14),
                      ),
                      Text(
                        ticket.seatNumber.toString(),
                        style: const TextStyle(
                          color: tdWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 65),

              // Qrcode
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QrImageView(
                  data: ticket.id,
                  version: QrVersions.auto,
                  size: 180, // Tăng từ 150 lên 180
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: tdRed, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Không thể tải thông tin vé',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Đã xảy ra lỗi không xác định',
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(backgroundColor: tdRed),
            child: const Text('Quay về trang chủ'),
          ),
        ],
      ),
    );
  }

  String _formatDay(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d').format(date);
    } catch (e) {
      return '';
    }
  }

  String _formatDayOfWeek(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('E').format(date);
    } catch (e) {
      return '';
    }
  }

  String _formatTime(String timeStr) {
    try {
      final timeParts = timeStr.split(':');
      return '${timeParts[0]}:${timeParts[1]}';
    } catch (e) {
      return timeStr;
    }
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
