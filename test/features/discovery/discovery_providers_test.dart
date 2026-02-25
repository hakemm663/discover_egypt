import 'package:discover_egypt/app/providers.dart';
import 'package:discover_egypt/core/models/user_model.dart';
import 'package:discover_egypt/core/repositories/api_clients/discovery_api_clients.dart';
import 'package:discover_egypt/core/repositories/discovery_repositories.dart';
import 'package:discover_egypt/core/repositories/firestore/discovery_firestore_client.dart';
import 'package:discover_egypt/core/repositories/models/discovery_models.dart';
import 'package:discover_egypt/core/repositories/models/pagination_models.dart';
import 'package:discover_egypt/core/services/auth_service.dart';
import 'package:discover_egypt/features/cars/cars_provider.dart';
import 'package:discover_egypt/features/hotels/hotels_provider.dart';
import 'package:discover_egypt/features/restaurants/restaurants_provider.dart';
import 'package:discover_egypt/features/tours/tours_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthService extends AuthService {
  @override
  User? get currentUser => null;
}

class _CapturingDiscoveryRepository extends DiscoveryRepository {
  _CapturingDiscoveryRepository()
      : super(
          hotelsApiClient: HotelsApiClient(),
          toursApiClient: ToursApiClient(),
          carsApiClient: CarsApiClient(),
          restaurantsApiClient: RestaurantsApiClient(),
          firestoreClient: DiscoveryFirestoreClient(),
        );

  String? hotelsUserId;
  String? toursUserId;
  String? carsUserId;
  String? restaurantsUserId;

  @override
  Future<PaginatedResult<HotelListing>> getHotels({
    required String userId,
    required PaginationQuery query,
  }) async {
    hotelsUserId = userId;
    return PaginatedResult(items: const [], page: query.page, pageSize: query.pageSize, totalCount: 0);
  }

  @override
  Future<PaginatedResult<TourListing>> getTours({required String userId, required PaginationQuery query}) async {
    toursUserId = userId;
    return PaginatedResult(items: const [], page: query.page, pageSize: query.pageSize, totalCount: 0);
  }

  @override
  Future<PaginatedResult<CarListing>> getCars({required String userId, required PaginationQuery query}) async {
    carsUserId = userId;
    return PaginatedResult(items: const [], page: query.page, pageSize: query.pageSize, totalCount: 0);
  }

  @override
  Future<PaginatedResult<RestaurantListing>> getRestaurants({
    required String userId,
    required PaginationQuery query,
  }) async {
    restaurantsUserId = userId;
    return PaginatedResult(items: const [], page: query.page, pageSize: query.pageSize, totalCount: 0);
  }
}

void main() {
  group('Discovery providers user id behavior', () {
    test('uses authenticated profile id when available', () async {
      final fakeRepository = _CapturingDiscoveryRepository();
      final user = UserModel(
        id: 'user-123',
        email: 'user@example.com',
        fullName: 'User',
        createdAt: DateTime(2024),
      );

      final container = ProviderContainer(
        overrides: [
          discoveryRepositoryProvider.overrideWithValue(fakeRepository),
          authServiceProvider.overrideWithValue(_FakeAuthService()),
          currentUserProvider.overrideWith((ref) => Stream.value(user)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(hotelsProvider.future);
      await container.read(toursProvider.future);
      await container.read(carsProvider.future);
      await container.read(restaurantsProvider.future);

      expect(fakeRepository.hotelsUserId, 'user-123');
      expect(fakeRepository.toursUserId, 'user-123');
      expect(fakeRepository.carsUserId, 'user-123');
      expect(fakeRepository.restaurantsUserId, 'user-123');
    });

    test('falls back to explicit guest user id when unauthenticated', () async {
      final fakeRepository = _CapturingDiscoveryRepository();

      final container = ProviderContainer(
        overrides: [
          discoveryRepositoryProvider.overrideWithValue(fakeRepository),
          authServiceProvider.overrideWithValue(_FakeAuthService()),
          currentUserProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(hotelsProvider.future);

      expect(fakeRepository.hotelsUserId, 'guest-user');
    });
  });
}
