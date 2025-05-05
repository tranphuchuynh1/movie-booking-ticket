class ApiConstants {
  // Base URL API
  static const String baseUrl = 'https://movieticketsv1.runasp.net/api';

  // endpoint movies
  static const String moviesEndpoint = '/movies';
  static const String movieTicketEndpoint = '/orders/movies/{userId}';
  static const String myTicketEndpoint =
      '/orders/movies/{userId}/tickets/{movieId}';

  // endpoint booking
  static const String bookingsEndpoint = '/bookings';

  // endpoint ticket
  static const String ticketsEndpoint = '/tickets';

  // endpoint account
  static const String registerEndpoint = '/account/register';
  static const String loginEndpoint = '/account/login';
  static const String getProfileEndpoint = '/account/{userId}';
  static const String updateProfileEndpoint = '/account/update-info';
  static const String updateAvatarEndpoint = '/account/update-avatar';
  static const String changePasswordEndpoint = '/account/change-password';
  // --------------------------------------------------------
}
