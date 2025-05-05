import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_ticket/features/select_seat_movie/screens/select_seat_skeleton.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/payment/order_request.dart';
import '../../auth/controllers/save_token_user_service.dart';
import '../../payment/controllers/booking_controller.dart';
import '../bloc/select_seat_movie_bloc.dart';

class SelectSeatMovieScreen extends StatefulWidget {
  final String movieId;

  const SelectSeatMovieScreen({super.key, required this.movieId});

  @override
  State<SelectSeatMovieScreen> createState() => _SelectSeatMovieScreenState();
}

class _SelectSeatMovieScreenState extends State<SelectSeatMovieScreen> {
  final SelectSeatBloc _selectSeatBloc = SelectSeatBloc();

  Future<void> _checkPendingOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? pendingOrderId = prefs.getString('pending_order_id');

      if (pendingOrderId != null) {
        print("Found pending order: $pendingOrderId");

        try {
          final bookingController = BookingController();

          // Kiểm tra trạng thái hiện tại
          final statusResponse = await bookingController.getPaymentStatus(pendingOrderId);
          print("Pending order status: ${statusResponse}");

          // Trạng thái có thể nằm trong trường "status" hoặc trong nested object
          final orderStatus = statusResponse['status'] ??
              (statusResponse['data'] is Map ?
              statusResponse['data']['status'] : null);

          print("Order status extracted: $orderStatus");

          // Dù trạng thái là gì, luôn xóa thông tin đơn hàng đang chờ
          await prefs.remove('pending_order_id');
          await prefs.remove('pending_order_time');

          // Đánh dấu cần làm mới danh sách ghế nếu đơn hàng chưa hoàn tất
          if (orderStatus != 'SUCCESS' && orderStatus != 'COMPLETED') {
            await prefs.setBool('should_refresh_seats', true);
            print("Order not completed, marking seats for refresh");
          }
        } catch (e) {
          print("Error checking order status: $e");
          // Xóa thông tin đơn hàng đang chờ
          await prefs.remove('pending_order_id');
          await prefs.remove('pending_order_time');
          // Đánh dấu cần làm mới danh sách ghế dù có lỗi
          await prefs.setBool('should_refresh_seats', true);
        }
      }
    } catch (e) {
      print("Error in _checkPendingOrders: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Khi mới khởi tạo màn hình
    _selectSeatBloc.add(FetchShowtimesEvent(widget.movieId));

    // Check order status
    _checkPendingOrders();

    // Đợi một khoảng thời gian ngắn để dữ liệu được tải
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSelectFirstDateAndTime();

      //  Luôn làm mới danh sách ghế khi vào màn hình
      _forceRefreshSeats();
    });
  }

  void _forceRefreshSeats() {
    Future.delayed(Duration(seconds: 1), () async {
      if (_selectSeatBloc.state.selectedShowtime != null) {
        print("Checking if seats need refresh for showtime: ${_selectSeatBloc.state.selectedShowtime!.id}");

        // Kiểm tra xem có cần làm mới không
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool shouldRefresh = prefs.getBool('should_refresh_seats') ?? false;

        if (shouldRefresh) {
          print("Refreshing seats data - forcing refresh from server");

          // Nếu cần làm mới, thêm một timestamp để đảm bảo không bị cache
          final options = Options(
            headers: {
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
              'x-refresh': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          );

          // Gọi API với options
          if (_selectSeatBloc.state.selectedShowtime?.id != null) {
            // Thực hiện fetch 2 lần với khoảng cách ngắn để đảm bảo dữ liệu mới
            _selectSeatBloc.add(FetchBookedSeatsEvent(_selectSeatBloc.state.selectedShowtime!.id!));

            // Đợi một khoảng thời gian ngắn và fetch lại
            Future.delayed(Duration(seconds: 1), () {
              if (mounted && _selectSeatBloc.state.selectedShowtime?.id != null) {
                _selectSeatBloc.add(FetchBookedSeatsEvent(_selectSeatBloc.state.selectedShowtime!.id!));
              }
            });
          }

          // Đặt lại flag
          await prefs.setBool('should_refresh_seats', false);
        } else {
          // Vẫn làm mới một lần để đảm bảo dữ liệu mới nhất
          if (_selectSeatBloc.state.selectedShowtime?.id != null) {
            _selectSeatBloc.add(FetchBookedSeatsEvent(_selectSeatBloc.state.selectedShowtime!.id!));
          }
        }
      }
    });
  }


  void _autoSelectFirstDateAndTime() {
    final state = _selectSeatBloc.state;

    // Kiểm tra trạng thái dữ liệu
    if (state.status != SelectSeatStatus.success ||
        state.showtimesByDate.isEmpty) {
      // Nếu dữ liệu chưa sẵn sàng, thử lại sau
      Future.delayed(const Duration(milliseconds: 300), () {
        _autoSelectFirstDateAndTime();
      });
      return;
    }

    // Lấy danh sách ngày còn hiệu lực
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final validDates =
        state.showtimesByDate.keys.where((dateStr) {
            try {
              final date = DateTime.parse(dateStr);
              return date.isAtSameMomentAs(today) || date.isAfter(today);
            } catch (_) {
              return false;
            }
          }).toList()
          ..sort();

    if (validDates.isEmpty) return;

    // Chọn ngày đầu tiên còn hiệu lực
    final firstValidDate = validDates.first;
    _selectSeatBloc.add(SelectDateEvent(firstValidDate));
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
              return const Center(child: SelectSeatSkeleton());
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
                        _selectSeatBloc.add(
                          FetchShowtimesEvent(widget.movieId),
                        );
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _autoSelectFirstDateAndTime();
                        });
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
                            image: NetworkImage(
                              state.selectedShowtime!.movieImage!,
                            ),
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
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          context.go('/detail', extra: widget.movieId);
                        },
                      ),
                    ),
                  ),

                  // Main content
                  Positioned.fill(
                    top: 250,
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
                          Expanded(child: _buildSeatSection(context, state)),

                          // Seat legend
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _seatLegend(tdWhite, "Ghế trống"),
                                const SizedBox(width: 20),
                                _seatLegend(tdGreyDark, "Ghế đã đặt"),
                                const SizedBox(width: 20),
                                _seatLegend(tdRed, "Ghế đã chọn"),
                                if (state.seatMatrix.any(
                                  (row) => row.any(
                                    (seat) =>
                                        seat.type?.toLowerCase().contains(
                                          'vip',
                                        ) ??
                                        false,
                                  ),
                                ))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: _seatLegend(Colors.amber, "VIP"),
                                  ),
                              ],
                            ),
                          ),

                          // 1. Date selection ^^
                          _buildDateSection(context, state),

                          // 2. Time selection
                          _buildTimeSection(context, state),

                          // 3. Total price and Buy button
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Seat matrix
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  state.seatMatrix.map((row) {
                    if (row.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            row.map((seat) {
                              bool isVipSeat =
                                  (seat.type?.toLowerCase().contains('vip') ??
                                      false);
                              bool isDoubleSeat =
                                  (seat.type?.toLowerCase().contains('đôi') ??
                                      false);
                              bool isTaken = state.bookedSeatIds.contains(
                                seat.seatId,
                              );

                              Color seatColor;
                              if (isTaken) {
                                seatColor = Colors.grey.shade700;
                              } else if (seat.isSelected) {
                                seatColor = tdRed;
                              } else {
                                seatColor = isVipSeat ? Colors.amber : tdWhite;
                              }

                              return Container(
                                width: isDoubleSeat ? 48 : 32,
                                height: 32,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 1,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap:
                                        isTaken
                                            ? null
                                            : () => context
                                                .read<SelectSeatBloc>()
                                                .add(
                                                  ToggleSeatEvent(
                                                    seat.seatId ?? '',
                                                  ),
                                                ),
                                    child: Icon(
                                      isDoubleSeat
                                          ? Icons.weekend
                                          : Icons.chair,
                                      color: seatColor,
                                      size: isDoubleSeat ? 35 : 24,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, SelectSeatState state) {
    final dates = state.showtimesByDate.keys.toList();
    final now = DateTime.now();

    final validDates =
        dates.where((dateStr) {
          try {
            final date = DateTime.parse(dateStr);
            return date.isAfter(now.subtract(const Duration(days: 1)));
          } catch (_) {
            return false;
          }
        }).toList();

    if (validDates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No dates available', style: TextStyle(color: tdWhite)),
      );
    }

    validDates.sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Chọn Ngày',
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

                final dayOfWeek =
                    dateTime != null ? DateFormat('E').format(dateTime) : '';
                final dayOfMonth =
                    dateTime != null ? DateFormat('d').format(dateTime) : '';

                return GestureDetector(
                  onTap:
                      () => context.read<SelectSeatBloc>().add(
                        SelectDateEvent(date),
                      ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayOfWeek,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Please select a date first',
          style: TextStyle(color: tdWhite),
        ),
      );
    }

    // Lấy tất cả các suất chiếu cho ngày đã chọn
    final showtimesForDate = state.showtimesByDate[selectedDate] ?? [];
    if (showtimesForDate.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No showtimes available for this date',
          style: TextStyle(color: tdWhite),
        ),
      );
    }

    final now = DateTime.now();

    // Sắp xếp theo thời gian
    showtimesForDate.sort((a, b) {
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
              'Chọn Giờ',
              style: TextStyle(color: tdWhite, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: showtimesForDate.length,
              itemBuilder: (context, index) {
                final showtime = showtimesForDate[index];
                final isSelected = showtime.id == state.selectedShowtime?.id;

                // Kiểm tra xem suất chiếu đã qua chưa
                bool isPastTime = false;
                try {
                  if (showtime.time != null && showtime.date != null) {
                    final timeParts = showtime.time!.split(':');
                    final dateTime = DateTime.parse(showtime.date!);
                    final showtimeDateTime = DateTime(
                      dateTime.year,
                      dateTime.month,
                      dateTime.day,
                      int.parse(timeParts[0]),
                      int.parse(timeParts[1]),
                    );
                    isPastTime = showtimeDateTime.isBefore(now);
                  }
                } catch (e) {
                  print('Error checking time: $e');
                }

                return GestureDetector(
                  onTap:
                      isPastTime
                          ? null
                          : () {
                            context.read<SelectSeatBloc>().add(
                              SelectTimeEvent(showtime.id ?? ''),
                            );
                            if (showtime.id != null) {
                              context.read<SelectSeatBloc>().add(
                                FetchBookedSeatsEvent(showtime.id!),
                              );
                            }
                          },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
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
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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
    final hasSelectedShowtime = state.selectedShowtime != null;
    final numberFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );

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
                "Thành Tiền",
                style: TextStyle(color: tdWhite70, fontSize: 16),
              ),
              Text(
                numberFormat.format(state.totalPrice),
                style: const TextStyle(
                  color: tdWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Buy button
          ElevatedButton(
            onPressed:
                (hasSelectedSeats && hasSelectedShowtime)
                    ? () => _processPurchase(context, state)
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: tdRed,
              disabledBackgroundColor: tdWhite54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text(
              "Mua Vé",
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

  void _processPurchase(BuildContext context, SelectSeatState state) async {
    if (state.selectedShowtime == null) return;

    // Lưu movieId vào SharedPreferences trc khi route qua screen Vnpay
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_selected_movie_id', widget.movieId);

    // Hiển thị dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: tdRed),
                SizedBox(height: 16),
                Text(
                  'Đang xử lý thanh toán...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
    );

    try {
      // Lấy userId từ localStorage
      final user = await SaveTokenUserService.getUser();
      if (user == null || user.userId == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      // Tạo danh sách ticket requests
      final tickets =
          state.selectedSeats
              .map(
                (seat) => TicketRequest(
                  showtimeId: state.selectedShowtime!.id!,
                  seatId: seat.seatId ?? '',
                ),
              )
              .toList();

      // Sử dụng BookingController trực tiếp
      final bookingController = BookingController();

      // Tạo đơn hàng
      final orderResponse = await bookingController.createOrder(
        user.userId!,
        tickets,
        [], // Không có extras
      );

      // Lấy URL thanh toán
      final paymentUrl = await bookingController.getPaymentUrl(
        orderResponse.orderId,
        orderResponse.totalAmount,
      );

      Navigator.pop(context);

      context.go(
        '/payment_webview',
        extra: {'paymentUrl': paymentUrl, 'orderId': orderResponse.orderId},
      );
    } catch (e) {
      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị lỗi
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }
}
