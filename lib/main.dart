import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/routes/app_routes.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/dio/dio_client.dart';
import 'features/auth/controllers/save_token_user_service.dart';
import 'localization/app_localizations.dart';

Future<String> CheckkToken() async {
  final isLoggedIn = await SaveTokenUserService.isLoggedIn();

  if (isLoggedIn) {
    return '/home';
  } else {
    return '/';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio and ApiService
  final dio = DioClient.instance;

  final initialRoute = await CheckkToken();

  await setupAppLinks();

  runApp(MyApp(initialRoute: initialRoute));
}

late AppLinks _appLinks;

Future<void> setupAppLinks() async {
  _appLinks = AppLinks();

  // Xử lý initial link khi ứng dụng khởi động từ deep link
  final appLink = await _appLinks.getInitialAppLink();
  if (appLink != null) {
    handleDeepLink(appLink);
  }

  // Lắng nghe deep link khi ứng dụng đang chạy
  _appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      handleDeepLink(uri);
    }
  });
}

// Hàm xử lý deep link
void handleDeepLink(Uri uri) async {
  print('Received deep link: $uri');
  final prefs = await SharedPreferences.getInstance();

  // Nếu là link xác thực email
  if (uri.path.contains('verify-email') || uri.path.contains('confirm-email') ||
      uri.path.contains('email-verified')) {
    final token = uri.queryParameters['token'];
    final email = uri.queryParameters['email'];

    if (token != null && email != null) {
      // Đánh dấu đã xác thực
      await prefs.setBool('email_verified', true);

      // Lấy thông tin đăng nhập đã lưu
      final pendingUsername = prefs.getString('pending_username');
      final pendingPassword = prefs.getString('pending_password');

      if (pendingUsername != null && pendingPassword != null) {
        // Lưu để tự động đăng nhập
        await prefs.setString('verification_username', pendingUsername);
        await prefs.setString('verification_password', pendingPassword);

        // Xóa thông tin tạm
        await prefs.remove('pending_username');
        await prefs.remove('pending_password');

        //  Chuyển đến route login và trigger đăng nhập tự động
        await prefs.setBool('auto_login_pending', true);
        appRouter('/');  // Chuyển đến màn hình login
      }
    }
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final AuthBloc _authBloc = AuthBloc();

  MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Localization',
        locale: const Locale('en'),
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('vi', 'VN'), // Vietnamese
          Locale('es', 'ES'), // Spanish
          Locale('fr', 'FR'), // French
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate, // Custom localization delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData.dark(),
        routerConfig: appRouter(initialRoute),
      ),
    );
  }
}
