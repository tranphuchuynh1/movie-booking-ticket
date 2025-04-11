import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie.dart';
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
        builder: (context, state) => SelectSeatMovieScreen(),
      ),
      GoRoute(
        path: '/ticket',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return TicketMovieScreen(movie: movie);
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
