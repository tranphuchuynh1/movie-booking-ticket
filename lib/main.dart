import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_booking_ticket/core/routes/app_routes.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
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

  runApp(MyApp(initialRoute: initialRoute));
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
