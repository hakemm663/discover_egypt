import 'api_clients/discovery_api_clients.dart';
import 'firestore/discovery_firestore_client.dart';
import 'models/discovery_models.dart';
import '../constants/image_urls.dart';
import 'models/pagination_models.dart';

class HomeFeed {
  final List<HotelListing> hotels;
  final List<TourListing> tours;
  final List<TourListing> recommendedTours;
  final List<DestinationListing> destinations;

  const HomeFeed({
    required this.hotels,
    required this.tours,
    required this.recommendedTours,
    required this.destinations,
  });
}

abstract class HotelsRepository {
  Future<PaginatedResult<HotelListing>> getHotels({
    required String userId,
    required PaginationQuery query,
  });
}

abstract class ToursRepository {
  Future<PaginatedResult<TourListing>> getTours({
    required String userId,
    required PaginationQuery query,
  });
}

abstract class CarsRepository {
  Future<PaginatedResult<CarListing>> getCars({
    required String userId,
    required PaginationQuery query,
  });
}

abstract class RestaurantsRepository {
  Future<PaginatedResult<RestaurantListing>> getRestaurants({
    required String userId,
    required PaginationQuery query,
  });
}

abstract class HomeRepository {
  Future<HomeFeed> getHomeFeed({required String userId});
}

class DiscoveryRepository
    implements HotelsRepository, ToursRepository, CarsRepository, RestaurantsRepository, HomeRepository {
  final HotelsApiClient hotelsApiClient;
  final ToursApiClient toursApiClient;
  final CarsApiClient carsApiClient;
  final RestaurantsApiClient restaurantsApiClient;
  final DiscoveryFirestoreClient firestoreClient;

  DiscoveryRepository({
    required this.hotelsApiClient,
    required this.toursApiClient,
    required this.carsApiClient,
    required this.restaurantsApiClient,
    required this.firestoreClient,
  });

  @override
  Future<PaginatedResult<HotelListing>> getHotels({
    required String userId,
    required PaginationQuery query,
  }) async {
    final response = await hotelsApiClient.fetchHotels(query);
    final signals = await firestoreClient.fetchUserSignals(userId: userId);
    return PaginatedResult(
      items: response.items
          .map((e) => HotelListing.fromApi(e, isBookmarked: signals.bookmarkedHotelIds.contains(e['id'])))
          .toList(growable: false),
      page: response.page,
      pageSize: response.pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<PaginatedResult<TourListing>> getTours({required String userId, required PaginationQuery query}) async {
    final response = await toursApiClient.fetchTours(query);
    final signals = await firestoreClient.fetchUserSignals(userId: userId);
    return PaginatedResult(
      items: response.items
          .map((e) => TourListing.fromApi(
                e,
                viewedRecently: signals.recentlyViewedTourIds.contains(e['id']),
              ))
          .toList(growable: false),
      page: response.page,
      pageSize: response.pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<PaginatedResult<CarListing>> getCars({required String userId, required PaginationQuery query}) async {
    final response = await carsApiClient.fetchCars(query);
    final signals = await firestoreClient.fetchUserSignals(userId: userId);
    return PaginatedResult(
      items: response.items
          .map((e) => CarListing.fromApi(e, isBookmarked: signals.bookmarkedCarIds.contains(e['id'])))
          .toList(growable: false),
      page: response.page,
      pageSize: response.pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<PaginatedResult<RestaurantListing>> getRestaurants({
    required String userId,
    required PaginationQuery query,
  }) async {
    final response = await restaurantsApiClient.fetchRestaurants(query);
    final signals = await firestoreClient.fetchUserSignals(userId: userId);
    return PaginatedResult(
      items: response.items
          .map(
            (e) => RestaurantListing.fromApi(
              e,
              isBookmarked: signals.bookmarkedRestaurantIds.contains(e['id']),
            ),
          )
          .toList(growable: false),
      page: response.page,
      pageSize: response.pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<HomeFeed> getHomeFeed({required String userId}) async {
    final hotels = await getHotels(
      userId: userId,
      query: const PaginationQuery(page: 1, pageSize: 3, filters: {'sortBy': 'Rating'}),
    );
    final tours = await getTours(userId: userId, query: const PaginationQuery(page: 1, pageSize: 2));
    final recommended = await getTours(
      userId: userId,
      query: const PaginationQuery(page: 1, pageSize: 2, filters: {'category': 'Adventure'}),
    );

    return HomeFeed(
      hotels: hotels.items,
      tours: tours.items,
      recommendedTours: recommended.items,
      destinations: const [
        DestinationListing(name: 'Pyramids of Giza', image: Img.pyramidsMain),
        DestinationListing(name: 'Luxor Temple', image: Img.luxorTemple),
        DestinationListing(name: 'Nile River', image: Img.nileRiver),
      ],
    );
  }
}
