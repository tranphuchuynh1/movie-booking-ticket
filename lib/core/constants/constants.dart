class ApiConstants {
  // Base URL API
  static const String baseUrl = 'https://minhtue-001-site1.ktempurl.com/api';

  // endpoint movies
  static const String moviesEndpoint = '/movies';
  static const String movieTicketEndpoint = '/orders/movies/{userId}';
  static const String myTicketendpoint =
      '/orders/movies/{userId}/tickets/{movieId}';

  // endpoint booking
  static const String bookingsEndpoint = '/bookings';

  // endpoint ticket
  static const String ticketsEndpoint = '/tickets';

  // endpoint auth
  static const String registerEndpoint = '/account/register';
  static const String loginEndpoint = '/account/login';
  // --------------------------------------------------------
}
