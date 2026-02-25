class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'https://api.discoveregypt.com/v1';

  // Receive timeout in milliseconds
  static const int receiveTimeout = 15000;

  // Connection timeout in milliseconds
  static const int connectionTimeout = 15000;

  //
  // Endpoints
  //
  static const String hotelsEndpoint = '/hotels';
  static const String toursEndpoint = '/tours';
  static const String carsEndpoint = '/cars';
  static const String restaurantsEndpoint = '/restaurants';
  static const String flightsEndpoint = '/flights';
  static const String bookingsEndpoint = '/bookings';
  static const String authEndpoint = '/auth';
  static const String profileEndpoint = '/profile';
}
