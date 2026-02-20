import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/hotel_model.dart';
import '../models/tour_model.dart';
import '../models/car_model.dart';
import '../models/restaurant_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== HOTELS ==========

  Future<List<HotelModel>> getHotels({
    String? city,
    double? minPrice,
    double? maxPrice,
    int? minRating,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(AppConstants.hotelsCollection);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (minPrice != null) {
      query = query.where('pricePerNight', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('pricePerNight', isLessThanOrEqualTo: maxPrice);
    }

    query = query.where('isAvailable', isEqualTo: true);
    query = query.orderBy('rating', descending: true);
    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => HotelModel.fromJson(doc.data())).toList();
  }

  Future<HotelModel?> getHotelById(String id) async {
    final doc = await _firestore
        .collection(AppConstants.hotelsCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return HotelModel.fromJson(doc.data()!);
  }

  Stream<List<HotelModel>> getHotelsStream({int limit = 20}) {
    return _firestore
        .collection(AppConstants.hotelsCollection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HotelModel.fromJson(doc.data())).toList());
  }

  // ========== TOURS ==========

  Future<List<TourModel>> getTours({
    String? city,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(AppConstants.toursCollection);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    query = query.where('isAvailable', isEqualTo: true);
    query = query.orderBy('rating', descending: true);
    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => TourModel.fromJson(doc.data())).toList();
  }

  Future<TourModel?> getTourById(String id) async {
    final doc = await _firestore
        .collection(AppConstants.toursCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return TourModel.fromJson(doc.data()!);
  }

  Stream<List<TourModel>> getToursStream({int limit = 20}) {
    return _firestore
        .collection(AppConstants.toursCollection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TourModel.fromJson(doc.data())).toList());
  }

  // ========== CARS ==========

  Future<List<CarModel>> getCars({
    String? city,
    String? type,
    bool? withDriver,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(AppConstants.carsCollection);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    if (withDriver != null) {
      query = query.where('withDriver', isEqualTo: withDriver);
    }

    query = query.where('isAvailable', isEqualTo: true);
    query = query.orderBy('rating', descending: true);
    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => CarModel.fromJson(doc.data())).toList();
  }

  Future<CarModel?> getCarById(String id) async {
    final doc = await _firestore
        .collection(AppConstants.carsCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return CarModel.fromJson(doc.data()!);
  }

  // ========== RESTAURANTS ==========

  Future<List<RestaurantModel>> getRestaurants({
    String? city,
    String? cuisineType,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(AppConstants.restaurantsCollection);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (cuisineType != null) {
      query = query.where('cuisineTypes', arrayContains: cuisineType);
    }

    query = query.orderBy('rating', descending: true);
    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => RestaurantModel.fromJson(doc.data()))
        .toList();
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    final doc = await _firestore
        .collection(AppConstants.restaurantsCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return RestaurantModel.fromJson(doc.data()!);
  }

  // ========== BOOKINGS ==========

  Future<String> createBooking(BookingModel booking) async {
    final docRef = _firestore.collection(AppConstants.bookingsCollection).doc();
    final bookingWithId = BookingModel(
      id: docRef.id,
      userId: booking.userId,
      itemId: booking.itemId,
      type: booking.type,
      status: booking.status,
      itemName: booking.itemName,
      itemImage: booking.itemImage,
      startDate: booking.startDate,
      endDate: booking.endDate,
      guestCount: booking.guestCount,
      subtotal: booking.subtotal,
      serviceFee: booking.serviceFee,
      taxes: booking.taxes,
      discount: booking.discount,
      total: booking.total,
      createdAt: DateTime.now(),
    );

    await docRef.set(bookingWithId.toJson());
    return docRef.id;
  }

  Future<void> updateBookingStatus(
      String bookingId, BookingStatus status) async {
    await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .update({'status': status.name});
  }

  Future<void> updateBookingPayment({
    required String bookingId,
    required String paymentId,
    required String paymentMethod,
  }) async {
    await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .update({
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'isPaid': true,
      'paidAt': Timestamp.now(),
      'status': BookingStatus.confirmed.name,
    });
  }

  Future<void> persistPaymentReconciliation({
    required String bookingId,
    required String paymentId,
    required String paymentMethod,
    required String paymentStatus,
    required bool isPaid,
  }) async {
    await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .set({
      'id': bookingId,
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'isPaid': isPaid,
      'paidAt': isPaid ? Timestamp.now() : null,
      'status': isPaid ? BookingStatus.confirmed.name : BookingStatus.pending.name,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data()))
        .toList();
  }

  Future<BookingModel?> getBookingById(String id) async {
    final doc = await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return BookingModel.fromJson(doc.data()!);
  }

  // ========== REVIEWS ==========

  Future<void> createReview(ReviewModel review) async {
    final docRef = _firestore.collection(AppConstants.reviewsCollection).doc();
    final reviewWithId = ReviewModel(
      id: docRef.id,
      userId: review.userId,
      userName: review.userName,
      userAvatar: review.userAvatar,
      itemId: review.itemId,
      itemType: review.itemType,
      rating: review.rating,
      comment: review.comment,
      images: review.images,
      createdAt: DateTime.now(),
    );

    await docRef.set(reviewWithId.toJson());

    // Update item rating
    await _updateItemRating(review.itemId, review.itemType);
  }

  Future<List<ReviewModel>> getItemReviews(String itemId) async {
    final snapshot = await _firestore
        .collection(AppConstants.reviewsCollection)
        .where('itemId', isEqualTo: itemId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ReviewModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> _updateItemRating(String itemId, String itemType) async {
    final reviews = await getItemReviews(itemId);
    if (reviews.isEmpty) return;

    final avgRating =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    String collection;
    switch (itemType) {
      case 'hotel':
        collection = AppConstants.hotelsCollection;
        break;
      case 'tour':
        collection = AppConstants.toursCollection;
        break;
      case 'car':
        collection = AppConstants.carsCollection;
        break;
      case 'restaurant':
        collection = AppConstants.restaurantsCollection;
        break;
      default:
        return;
    }

    await _firestore.collection(collection).doc(itemId).update({
      'rating': avgRating,
      'reviewCount': reviews.length,
    });
  }
}