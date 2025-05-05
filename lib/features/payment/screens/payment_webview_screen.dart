import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:movie_booking_ticket/theme.dart';

import '../../../core/dio/dio_client.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.orderId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isOrderProcessed = false; // Đã xử lý đơn hàng chưa

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });

            if (url.startsWith('myapp://payment-result')) {
              _handleCallback(url);
            }
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('myapp://payment-result')) {
              _handleCallback(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    // Đăng ký lắng nghe lifecycle app
    WidgetsBinding.instance.addObserver(this);

    // Lưu thông tin đơn hàng đang xử lý
    _trackPendingOrder();
  }

  // Lưu thông tin đơn hàng đang thanh toán
  Future<void> _trackPendingOrder() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_order_id', widget.orderId);
      await prefs.setInt('pending_order_time', DateTime.now().millisecondsSinceEpoch);
      print("Tracking pending order: ${widget.orderId}");
    } catch (e) {
      print("Error tracking pending order: $e");
    }
  }

  @override
  void dispose() {
    // Nếu chưa xử lý đơn hàng (chưa thanh toán thành công hoặc thất bại), hủy đơn
    if (!_isOrderProcessed) {
      _cancelOrder(widget.orderId);
    }

    // Hủy đăng ký lắng nghe lifecycle
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Khi app chuyển sang background hoặc bị tắt
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      if (!_isOrderProcessed) {
        _cancelOrder(widget.orderId);
      }
    }
  }

  Future<void> _handleCallback(String url) async {
    print("DEBUG - Callback URL: $url");
    final uri = Uri.parse(url);
    final success = uri.queryParameters['success']?.toLowerCase() == 'true';
    final message = uri.queryParameters['message'] ?? '';
    final orderId = uri.queryParameters['orderId'] ?? widget.orderId;

    if (success && orderId.isNotEmpty) {
      // Đánh dấu đã xử lý đơn hàng thành công
      _isOrderProcessed = true;

      // Xóa thông tin đơn đang chờ
      _clearPendingOrderInfo();

      // Chuyển đến màn hình vé
      Future.delayed(Duration(milliseconds: 100), () {
        context.go('/ticket', extra: orderId);
      });
    } else {
      // Đánh dấu đã xử lý đơn hàng
      _isOrderProcessed = true;

      // Đánh dấu cần làm mới danh sách ghế khi quay lại màn hình chọn ghế
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('should_refresh_seats', true);

      // Quay về màn hình chọn ghế
      SharedPreferences.getInstance().then((prefs) {
        final movieId = prefs.getString('last_selected_movie_id');
        if (movieId != null && movieId.isNotEmpty) {
          context.go('/select_seat', extra: movieId);
        } else {
          context.go('/home');
        }
      });
    }
  }

  // Xóa thông tin đơn hàng đang chờ
  Future<void> _clearPendingOrderInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_order_id');
      await prefs.remove('pending_order_time');
      // Đánh dấu cần làm mới danh sách ghế khi quay lại màn hình chọn ghế
      await prefs.setBool('should_refresh_seats', true);
      print("Cleared pending order info");
    } catch (e) {
      print("Error clearing pending order info: $e");
    }
  }

  // Hủy đơn hàng
  Future<void> _cancelOrder(String orderId) async {
    try {
      final dio = DioClient.instance;

      // Kiểm tra trạng thái hiện tại
      final statusResponse = await dio.get('/api/payments/$orderId/status');
      print("Order status: ${statusResponse.data}");

      // Chỉ hủy nếu đơn hàng vẫn ở trạng thái PENDING
      if (statusResponse.data['status'] == 'PENDING') {
        await dio.delete('/api/orders/$orderId');
        print("Order cancelled successfully: $orderId");

        // Xóa thông tin đơn hàng đang chờ
        await _clearPendingOrderInfo();
      }
    } catch (e) {
      print("Error cancelling order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Center(child: CircularProgressIndicator(color: tdRed)),
          ],
        ),
      ),
    );
  }
}