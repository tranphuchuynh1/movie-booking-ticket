import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_booking_ticket/core/routes/app_routes.dart';
import 'core/dio/dio_client.dart';
import 'features/home_movie/bloc/movie_bloc.dart';
import 'localization/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio and ApiService
  final dio = DioClient.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: appRouter,
    );
  }
}
