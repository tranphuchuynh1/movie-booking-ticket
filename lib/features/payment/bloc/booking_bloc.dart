import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/models/payment/order_request.dart';
import 'package:movie_booking_ticket/core/models/showtime_model.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';
import 'package:movie_booking_ticket/features/payment/controllers/booking_controller.dart';
import 'package:url_launcher/url_launcher.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingController _bookingController = BookingController();

  BookingBloc() : super(BookingState()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<CheckPaymentStatusEvent>(_onCheckPaymentStatus);
  }

  Future<void> _onCreateOrder(
      CreateOrderEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(state.copyWith(status: BookingStatus.loading));

    try {
      // Hiển thị thông tin chi tiết -> debug
      print("Tạo đơn hàng với showTimeId: ${event.showtimeId}");
      print("Số ghế đã chọn: ${event.selectedSeats.length}");

      final user = await SaveTokenUserService.getUser();
      if (user == null || user.userId == null) {
        emit(state.copyWith(
          status: BookingStatus.error,
          errorMessage: 'Người dùng chưa đăng nhập',
        ));
        return;
      }

      final tickets = event.selectedSeats.map((seat) {
        print("Ghế: ${seat.seatId}, Row: ${seat.row}, Number: ${seat.number}");
        return TicketRequest(
          showtimeId: event.showtimeId,
          seatId: seat.seatId ?? '',
        );
      }).toList();

      // Tạo đơn hàng
      print("Gửi request tạo đơn hàng...");
      final orderResponse = await _bookingController.createOrder(
        user.userId!,
        tickets,
        [], // Không có extras
      );

      print("Đơn hàng đã được tạo: ${orderResponse.orderId}");
      emit(state.copyWith(
        status: BookingStatus.orderCreated,
        orderId: orderResponse.orderId,
        totalAmount: orderResponse.totalAmount,
      ));

      // Tự động chuyển sang xử lý thanh toán
      add(ProcessPaymentEvent());
    } catch (e) {
      print("Error creating order: $e");
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: "Tạo đơn hàng thất bại: ${e.toString()}",
      ));
    }
  }

  Future<void> _onProcessPayment(
      ProcessPaymentEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(state.copyWith(status: BookingStatus.processingPayment));

    try {
      // Lấy URL thanh toán
      final paymentUrl = await _bookingController.getPaymentUrl(
          state.orderId!,
          state.totalAmount!
      );

      emit(state.copyWith(
        status: BookingStatus.paymentInitiated,
        paymentUrl: paymentUrl,
      ));

      // Mở URL trong trình duyệt web
      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(
          Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        emit(state.copyWith(
          status: BookingStatus.error,
          errorMessage: 'Không thể mở URL thanh toán',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: "Xử lý thanh toán thất bại: ${e.toString()}",
      ));
    }
  }

  Future<void> _onCheckPaymentStatus(
      CheckPaymentStatusEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(state.copyWith(status: BookingStatus.checkingPayment));

    // try {
    //   // Kiểm tra trạng thái thanh toán
    //   // final response = await _bookingController.checkPaymentStatus(state.orderId!);
    //
    //   if (response.status == 'success') {
    //     emit(state.copyWith(
    //       status: BookingStatus.paymentSuccess,
    //     ));
    //   } else {
    //     emit(state.copyWith(
    //       status: BookingStatus.paymentFailed,
    //       errorMessage: response.message,
    //     ));
    //   }
    // } catch (e) {
    //   emit(state.copyWith(
    //     status: BookingStatus.error,
    //     errorMessage: e.toString(),
    //   ));
    // }
  }

}