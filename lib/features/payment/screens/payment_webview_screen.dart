
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/payment/order_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:movie_booking_ticket/theme.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebViewScreen({
    Key? key,
    required this.paymentUrl,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

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
            // Kiểm tra callback URL
            if (request.url.startsWith('myapp://payment-result')) {
              _handleCallback(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleCallback(String url) {
    print("DEBUG - Callback URL: $url");
    final uri = Uri.parse(url);
    final success = uri.queryParameters['success']?.toLowerCase() == 'true';
    final message = uri.queryParameters['message'] ?? '';
    final orderId = uri.queryParameters['orderId'] ?? widget.orderId;

    print("DEBUG - Payment result: success=$success, orderId=$orderId, message=$message");

    if (success && orderId.isNotEmpty) {
      // can thêm delay nhỏ để đảm bảo state được cập nhật
      Future.delayed(Duration(milliseconds: 100), () {
        context.go('/ticket', extra: orderId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanh toán thất bại: $message')),
      );
      context.go('/select_seat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Hủy thanh toán
            context.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: tdRed),
            ),
        ],
      ),
    );
  }
}