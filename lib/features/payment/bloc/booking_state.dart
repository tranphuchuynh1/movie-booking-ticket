part of 'booking_bloc.dart';

enum BookingStatus {
  initial,
  loading,
  orderCreated,
  processingPayment,
  paymentInitiated,
  checkingPayment,
  paymentSuccess,
  paymentFailed,
  error
}

class BookingState {
  final BookingStatus status;
  final String? orderId;
  final int? totalAmount;
  final String? errorMessage;
  final String? paymentUrl;

  BookingState({
    this.status = BookingStatus.initial,
    this.orderId,
    this.totalAmount,
    this.errorMessage,
    this.paymentUrl,
  });

  // Không cần lưu ticketData nữa
  BookingState copyWith({
    BookingStatus? status,
    String? orderId,
    int? totalAmount,
    String? errorMessage,
    String? paymentUrl,
  }) {
    return BookingState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      totalAmount: totalAmount ?? this.totalAmount,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }
}

