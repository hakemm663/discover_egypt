import '../../api/generated/discovery_generated_api.dart';
import '../../api/generated/models.dart';
import '../../constants/image_urls.dart';
import '../models/pagination_models.dart';

class HotelsApiClient {
  HotelsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? DiscoveryGeneratedApi(baseUrl: AppConfig.baseUrl);

  final DiscoveryGeneratedApi _sdk;

  Uri listUri({String? city, String? sortBy}) => _sdk.listHotelsUri(city, sortBy);

  Future<PaginatedResult<Map<String, dynamic>>> fetchHotels(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _sdk.listHotelsUri(query.filters['city'], query.filters['sortBy']);
    final filtered = _hotels.where((item) {
      final city = query.filters['city'];
      return city == null || city == 'All' || item.city == city;
    }).toList();
    final sorted = _sort(filtered, query.filters['sortBy']);
    return _page(sorted.map((hotel) => hotel.toJson()).toList(growable: false), query);
  }

  List<Hotel> _sort(List<Hotel> source, String? sortBy) {
    final items = [...source];
    if (sortBy == 'Price: Low to High') {
      items.sort((a, b) => a.price.compareTo(b.price));
      return items;
    }
    if (sortBy == 'Price: High to Low') {
      items.sort((a, b) => b.price.compareTo(a.price));
      return items;
    }
    if (sortBy == 'Rating') {
      items.sort((a, b) => b.rating.compareTo(a.rating));
      return items;
    }
    items.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return items;
import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../constants/api_endpoints.dart';
import '../models/pagination_models.dart';

class DiscoveryApiException implements Exception {
  final String message;

  const DiscoveryApiException(this.message);

  @override
  String toString() => 'DiscoveryApiException: $message';
}

class DiscoveryHttpClient {
  final Dio _dio;

  DiscoveryHttpClient({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is List) {
        return {'items': data};
      }
      return const <String, dynamic>{};
    } on DioException catch (error) {
      throw DiscoveryApiException(_mapDioError(error));
    } catch (_) {
      throw const DiscoveryApiException('Unexpected error while loading discovery data.');
    }
  }

  String _mapDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return 'Server error. Please try again shortly.';
    }
    if (statusCode != null && statusCode >= 400) {
      return 'Request failed (${statusCode.toString()}). Please refresh and try again.';
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'No internet connection. Check your network and try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled. Please try again.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return 'Something went wrong while contacting the server.';
    }
  }
}

class HotelsApiClient {
  final DiscoveryHttpClient _httpClient;

  HotelsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  String get endpoint => ApiEndpoints.hotels;

  Future<PaginatedResult<Map<String, dynamic>>> fetchHotels(PaginationQuery query) async {
    final payload = await _httpClient.get(
      endpoint,
      queryParameters: _buildQueryParameters(query),
    );
    return _mapPaginated(payload, query);
  }
}

class ToursApiClient {
  ToursApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? DiscoveryGeneratedApi(baseUrl: AppConfig.baseUrl);

  final DiscoveryGeneratedApi _sdk;

  Uri listUri({String? category}) => _sdk.listToursUri(category);

  Future<PaginatedResult<Map<String, dynamic>>> fetchTours(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _sdk.listToursUri(query.filters['category']);
    final filtered = _tours.where((item) {
      final category = query.filters['category'];
      return category == null || category == 'All' || item.category == category;
    }).toList();
    return _page(filtered.map((tour) => tour.toJson()).toList(growable: false), query);
  final DiscoveryHttpClient _httpClient;

  ToursApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  String get endpoint => ApiEndpoints.tours;

  Future<PaginatedResult<Map<String, dynamic>>> fetchTours(PaginationQuery query) async {
    final payload = await _httpClient.get(
      endpoint,
      queryParameters: _buildQueryParameters(query),
    );
    return _mapPaginated(payload, query);
  }
}

class CarsApiClient {
  CarsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? DiscoveryGeneratedApi(baseUrl: AppConfig.baseUrl);

  final DiscoveryGeneratedApi _sdk;

  Uri listUri({String? type, bool? withDriverOnly}) => _sdk.listCarsUri(type, withDriverOnly);

  Future<PaginatedResult<Map<String, dynamic>>> fetchCars(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _sdk.listCarsUri(query.filters['type'], query.filters['withDriverOnly'] == 'true');
    final filtered = _cars.where((item) {
      final type = query.filters['type'];
      final withDriverOnly = query.filters['withDriverOnly'] == 'true';
      final typeMatches = type == null || type == 'All' || item.type == type;
      final driverMatches = !withDriverOnly || item.withDriver;
      return typeMatches && driverMatches;
    }).toList();
    return _page(filtered.map((car) => car.toJson()).toList(growable: false), query);
  final DiscoveryHttpClient _httpClient;

  CarsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  String get endpoint => ApiEndpoints.cars;

  Future<PaginatedResult<Map<String, dynamic>>> fetchCars(PaginationQuery query) async {
    final payload = await _httpClient.get(
      endpoint,
      queryParameters: _buildQueryParameters(query),
    );
    return _mapPaginated(payload, query);
  }
}

class RestaurantsApiClient {
  RestaurantsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? DiscoveryGeneratedApi(baseUrl: AppConfig.baseUrl);

  final DiscoveryGeneratedApi _sdk;

  Uri listUri({String? cuisine}) => _sdk.listRestaurantsUri(cuisine);

  Future<PaginatedResult<Map<String, dynamic>>> fetchRestaurants(PaginationQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _sdk.listRestaurantsUri(query.filters['cuisine']);
    final filtered = _restaurants.where((item) {
      final cuisine = query.filters['cuisine'];
      return cuisine == null || cuisine == 'All' || item.cuisine == cuisine;
    }).toList();
    return _page(filtered.map((restaurant) => restaurant.toJson()).toList(growable: false), query);
  final DiscoveryHttpClient _httpClient;

  RestaurantsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  String get endpoint => ApiEndpoints.restaurants;

  Future<PaginatedResult<Map<String, dynamic>>> fetchRestaurants(PaginationQuery query) async {
    final payload = await _httpClient.get(
      endpoint,
      queryParameters: _buildQueryParameters(query),
    );
    return _mapPaginated(payload, query);
  }
}

Map<String, dynamic> _buildQueryParameters(PaginationQuery query) {
  return <String, dynamic>{
    'page': query.page,
    'pageSize': query.pageSize,
    ...query.filters,
  };
}

PaginatedResult<Map<String, dynamic>> _mapPaginated(
  Map<String, dynamic> payload,
  PaginationQuery fallback,
) {
  final meta = payload['meta'];
  final List<dynamic> rawItems = switch (payload['items']) {
    final List<dynamic> items => items,
    _ => switch (payload['data']) {
        final List<dynamic> data => data,
        _ => const <dynamic>[],
      },
  };

  final page = _toInt((meta is Map<String, dynamic>) ? meta['page'] : payload['page']) ?? fallback.page;
  final pageSize =
      _toInt((meta is Map<String, dynamic>) ? meta['pageSize'] : payload['pageSize']) ?? fallback.pageSize;
  final totalCount = _toInt(
        (meta is Map<String, dynamic>) ? meta['totalCount'] ?? meta['total'] : payload['totalCount'],
      ) ??
      rawItems.length;

  return PaginatedResult(
    items: rawItems.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList(growable: false),
    page: page,
    pageSize: pageSize,
    totalCount: totalCount,
  );
}

const _hotels = [
  Hotel(id: '1', name: 'Pyramids View Hotel', city: 'Cairo', location: 'Giza, Cairo', image: Img.hotelLuxury, rating: 4.8, reviewCount: 520, price: 120.0, amenities: ['WiFi', 'Pool', 'Restaurant', 'Spa'], stars: 5),
  Hotel(id: '2', name: 'Nile Ritz Carlton', city: 'Cairo', location: 'Downtown Cairo', image: Img.hotelPool, rating: 4.9, reviewCount: 890, price: 250.0, amenities: ['WiFi', 'Pool', 'Gym', 'Restaurant'], stars: 5),
  Hotel(id: '3', name: 'Steigenberger Resort', city: 'Hurghada', location: 'Hurghada', image: Img.hotelResort, rating: 4.7, reviewCount: 430, price: 180.0, amenities: ['WiFi', 'Beach', 'Pool', 'Spa'], stars: 5),
  Hotel(id: '4', name: 'Hilton Luxor Resort', city: 'Luxor', location: 'Luxor City', image: Img.hotelRoom, rating: 4.6, reviewCount: 350, price: 140.0, amenities: ['WiFi', 'Pool', 'Restaurant'], stars: 4),
  Hotel(id: '5', name: 'Four Seasons Alexandria', city: 'Alexandria', location: 'Alexandria Corniche', image: Img.hotelLobby, rating: 4.9, reviewCount: 670, price: 300.0, amenities: ['WiFi', 'Beach', 'Spa', 'Pool'], stars: 5),
];

const _tours = [
  Tour(id: '1', name: 'Pyramids & Sphinx Day Tour', category: 'Historical', duration: 'Full Day • 8 hours', image: Img.pyramidsMain, rating: 4.9, reviewCount: 1250, price: 65.0, pickupIncluded: true),
  Tour(id: '2', name: 'Nile River Cruise', category: 'Cruise', duration: '3 Days • Luxor to Aswan', image: Img.nileCruise, rating: 4.8, reviewCount: 890, price: 320.0, pickupIncluded: true),
  Tour(id: '3', name: 'Luxor Temple & Valley of Kings', category: 'Historical', duration: 'Full Day • 10 hours', image: Img.luxorTemple, rating: 4.7, reviewCount: 720, price: 85.0, pickupIncluded: true),
  Tour(id: '4', name: 'Red Sea Diving Adventure', category: 'Adventure', duration: 'Half Day • 4 hours', image: Img.coralReef, rating: 4.9, reviewCount: 540, price: 95.0, pickupIncluded: false),
  Tour(id: '5', name: 'Desert Safari & BBQ', category: 'Adventure', duration: 'Evening • 5 hours', image: Img.pyramidsCamels, rating: 4.6, reviewCount: 380, price: 75.0, pickupIncluded: true),
];

const _cars = [
  Car(id: '1', name: 'Toyota Camry 2023', type: 'Sedan', image: Img.carSedan, seats: 5, transmission: 'Automatic', rating: 4.8, reviewCount: 245, price: 45.0, withDriver: true, driverPrice: 25),
  Car(id: '2', name: 'BMW X5', type: 'SUV', image: Img.carSuv, seats: 7, transmission: 'Automatic', rating: 4.9, reviewCount: 189, price: 85.0, withDriver: true, driverPrice: 35),
  Car(id: '3', name: 'Mercedes C-Class', type: 'Luxury', image: Img.carLuxury, seats: 5, transmission: 'Automatic', rating: 4.9, reviewCount: 156, price: 120.0, withDriver: true, driverPrice: 45),
  Car(id: '4', name: 'Hyundai Staria', type: 'Van', image: Img.carVan, seats: 8, transmission: 'Automatic', rating: 4.7, reviewCount: 320, price: 70.0, withDriver: false, driverPrice: 0),
];

const _restaurants = [
  Restaurant(id: '1', name: 'Koshary Abou Tarek', cuisine: 'Egyptian', location: 'Downtown Cairo', image: Img.koshari, rating: 4.7, reviewCount: 2100, priceRange: r'$4-$10', deliveryTime: 30, delivery: true),
  Restaurant(id: '2', name: 'Sequoia', cuisine: 'Mediterranean', location: 'Zamalek, Cairo', image: Img.restaurant, rating: 4.8, reviewCount: 1400, priceRange: r'$30-$60', deliveryTime: 45, delivery: true),
  Restaurant(id: '3', name: 'Felfela Restaurant', cuisine: 'Egyptian', location: 'Downtown Cairo', image: Img.egyptianFood, rating: 4.5, reviewCount: 980, priceRange: r'$8-$20', deliveryTime: 25, delivery: false),
  Restaurant(id: '4', name: 'Kazoku', cuisine: 'Asian', location: 'New Cairo', image: Img.restaurantInterior, rating: 4.9, reviewCount: 760, priceRange: r'$40-$80', deliveryTime: 40, delivery: true),
];
int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
