import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie.dart';
import 'package:movie_booking_ticket/features/profile_screen/screens/profile_screen.dart';
import 'package:movie_booking_ticket/features/search_movie/screens/search_screen.dart';
import 'package:movie_booking_ticket/features/ticket_history/screen/ticket_history.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home_movie/screens/home_screen.dart';
import '../../features/detail_movie/screens/detail_movie_screen.dart';
import '../../features/select_seat_movie/screens/select_seat_movie_screen.dart';
import '../../features/ticket_seat_movie/screens/ticket_movie_screen.dart';


final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen()
    ),

    GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen()
    ),

    GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen()
    ),

    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailScreen(movie: movie);
      },
    ),

    GoRoute(
        path: '/select_seat',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return SelectSeatMovieScreen(movie: movie);
        }
    ),

    GoRoute(
        path: '/ticket',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return TicketMovieScreen(movie: movie);
        }
    ),

    GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen()
    ),

    GoRoute(
        path: '/search',
        builder: (context , state) => SearchScreen()
    ),

    GoRoute(
        path: '/ticket_history',
        builder: (context, state) => TicketHistoryScreen()
    )
  ],
);
