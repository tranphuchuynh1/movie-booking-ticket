import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_booking_ticket/core/routes/app_routes.dart';
import 'core/services/dio_client.dart';
import 'localization/app_localizations.dart';

void main() {
  runApp(const MyApp());

  // Khởi tạo Dio một lần duy nhất khi app chạy
  Dio dio = DioClient.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Localization',
      locale: Locale('en'), // Default locale
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
      routerConfig: appRouter,
    );
  }
}
