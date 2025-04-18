import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/features/profile_screen/screens/change_password.dart';
import 'package:movie_booking_ticket/features/profile_screen/screens/edit_profile_screen.dart';
import 'package:movie_booking_ticket/features/profile_screen/screens/profile_screen.dart';
import 'package:movie_booking_ticket/features/search_movie/screens/search_screen.dart';
import 'package:movie_booking_ticket/features/ticket_history/screen/ticket_history.dart';
import 'package:movie_booking_ticket/features/auth/screens/login_screen.dart';
import 'package:movie_booking_ticket/features/auth/screens/register_screen.dart';
import 'package:movie_booking_ticket/features/home_movie/screens/home_screen.dart';
import 'package:movie_booking_ticket/features/detail_movie/screens/detail_movie_screen.dart';
import 'package:movie_booking_ticket/features/my_ticket_movie/screens/ticket_movie_screen.dart';
import 'package:movie_booking_ticket/features/select_seat_movie/screens/select_seat_movie_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/payment/screens/payment_webview_screen.dart';


GoRouter appRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      // GoRoute(path: '/auth_check', builder: (context, state) => AuthCheckScreen()),
      GoRoute(path: '/', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'detail/:movieId',
            builder:
                (context, state) => MovieDetailScreen(
                  movieId: state.pathParameters['movieId'] ?? '',
                ),
          ),
        ],
      ),

      GoRoute(
        path: '/search',
        builder: (context, state) => SearchScreen(),
        routes: [
          GoRoute(
            path: 'detail/:movieId',
            builder:
                (context, state) => MovieDetailScreen(
                  movieId: state.pathParameters['movieId'] ?? '',
                ),
          ),
        ],
      ),

      GoRoute(
        path: '/detail',
        builder:
            (context, state) =>
                MovieDetailScreen(movieId: state.extra as String),
      ),

      GoRoute(
        path: '/select_seat',
        builder: (context, state) {
          if (state.extra == null) {
            // case back từ màn hình thanh toán bị hủy
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải thông tin phim',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Quay về trang chủ'),
                    ),
                  ],
                ),
              ),
            );
          }

          final movieId = state.extra.toString();
          return SelectSeatMovieScreen(movieId: movieId);
        },
      ),

      GoRoute(
          path: '/payment_callback',
          builder: (context, state) {
            print("DEBUG - Payment callback route params: ${state.uri.queryParameters}");
            final success = state.uri.queryParameters['success']?.toLowerCase() == 'true';
            final message = state.uri.queryParameters['message'] ?? '';
            final orderId = state.uri.queryParameters['orderId'];

            if (success && orderId != null) {
              context.go('/ticket', extra: orderId);
            } else {
              // Lấy movieId từ SharedPreferences
              SharedPreferences.getInstance().then((prefs) {
                final movieId = prefs.getString('last_selected_movie_id');
                if (movieId != null && movieId.isNotEmpty) {
                  context.go('/select_seat', extra: movieId);
                } else {
                  context.go('/home');
                }
              });
            }

            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
      ),

      GoRoute(
        path: '/payment_webview',
        builder: (context, state) {
          final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
          return PaymentWebViewScreen(
            paymentUrl: params['paymentUrl'],
            orderId: params['orderId'],
          );
        },
      ),

      GoRoute(
        path: '/ticket',
        builder: (context, state) {
          print("DEBUG: state.extra = ${state.extra}");
          print("DEBUG: type of state.extra = ${state.extra?.runtimeType}");

          if (state.extra == null) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải thông tin vé - Thiếu thông tin đơn hàng',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Quay về trang chủ'),
                    ),
                  ],
                ),
              ),
            );
          }

          final orderId = state.extra.toString();
          return TicketMovieScreen(orderId: orderId);
        },
      ),

      GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/ticket_history',
        builder: (context, state) => TicketHistoryScreen(),
      ),
      GoRoute(
        path: '/change_password',
        builder: (context, state) => ChangePasswordScreen(),
      ),
    ],
  );
}
