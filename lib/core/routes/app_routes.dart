import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/features/profile_screen/screens/profile_screen.dart';
import 'package:movie_booking_ticket/features/ticket_seat_movie/screens/ticket_movie_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home_movie/screens/home_screen.dart';
import '../../features/detail_movie/screens/detail_movie_screen.dart';
import '../../features/select_seat_movie/screens/select_seat_movie_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) => MovieDetailScreen(),
    ),
    GoRoute(
      path: '/select_seat',
      builder: (context, state) => SelectSeatMovieScreen(),
    ),
    GoRoute(
      path: '/ticket',
      builder: (context, state) => TicketMovieScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),


  ],
);

