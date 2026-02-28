import '../config/app_config.dart';

class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.discoveregypt.com/v1';
  static const String firebaseBaseUrl = 'https://firestore.googleapis.com/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/update';
  static const String uploadAvatar = '/users/avatar';
  static const String deleteAccount = '/users/delete';

  // Hotels
  static const String hotels = '/hotels';
  static const String hotelDetails = '/hotels/{id}';
  static const String hotelRooms = '/hotels/{id}/rooms';
  static const String hotelReviews = '/hotels/{id}/reviews';

  // Tours
  static const String tours = '/tours';
  static const String tourDetails = '/tours/{id}';
  static const String tourSchedule = '/tours/{id}/schedule';
  static const String tourReviews = '/tours/{id}/reviews';

  // Cars
  static const String cars = '/cars';
  static const String carDetails = '/cars/{id}';
  static const String carAvailability = '/cars/{id}/availability';

  // Restaurants
  static const String restaurants = '/restaurants';
  static const String restaurantDetails = '/restaurants/{id}';
  static const String restaurantMenu = '/restaurants/{id}/menu';

  // Bookings
  static const String bookings = '/bookings';
  static const String bookingDetails = '/bookings/{id}';
  static const String cancelBooking = '/bookings/{id}/cancel';

  // Payments
  static const String createPaymentIntent = '/payments/create-intent';
  static const String confirmPayment = '/payments/confirm';
  static const String refundPayment = '/payments/refund';
  static const String walletCharge = '/payments/wallet/charge';
  static const String cashOnArrivalIntent = '/payments/cash-on-arrival';

  // Reviews
  static const String reviews = '/reviews';
  static const String createReview = '/reviews/create';

  // Wallet
  static const String wallet = '/wallet';
  static const String addFunds = '/wallet/add';
  static const String withdrawFunds = '/wallet/withdraw';
  static const String transactions = '/wallet/transactions';

  // Notifications
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/{id}/read';

  // Helper to replace path parameters
  static String withId(String endpoint, String id) {
    return endpoint.replaceAll('{id}', id);
  }
}
