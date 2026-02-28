import '../../api/generated/discovery_generated_api.dart';
import '../../api/generated/models.dart';
import '../../constants/image_urls.dart';
import '../models/pagination_models.dart';

class HotelsApiClient {
  HotelsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? const DiscoveryGeneratedApi();

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
export 'discovery_http_client.dart' show DiscoveryApiException, DiscoveryHttpClient;

import '../../constants/api_endpoints.dart';
import '../models/pagination_models.dart';
import 'discovery_fallback_catalog.dart';

class DiscoveryApiException implements Exception {
  const DiscoveryApiException(this.message);

  final String message;

  @override
  String toString() => 'DiscoveryApiException: $message';
}

class DiscoveryHttpClient {
  DiscoveryHttpClient({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  final Dio _dio;

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
      throw const DiscoveryApiException(
        'Unexpected error while loading discovery data.',
      );
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
import 'discovery_fallback_catalog.dart';
import 'discovery_http_client.dart';

class HotelsApiClient {
  HotelsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryGeneratedApi? sdk,
  })  : _httpClient = httpClient ?? DiscoveryHttpClient(),
        _sdk = sdk ?? const DiscoveryGeneratedApi();

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
  ToursApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.tours;

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
  CarsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
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
  RestaurantsApiClient({DiscoveryGeneratedApi? sdk}) : _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.restaurants;

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
  if (payload.containsKey('items') && payload['items'] != null && payload['items'] is! List) {
    throw const FormatException('Discovery API payload field "items" must be a list.');
  }
  if (payload.containsKey('data') && payload['data'] != null && payload['data'] is! List) {
    throw const FormatException('Discovery API payload field "data" must be a list.');
  }

  final meta = payload['meta'];

  final hasItems = payload.containsKey('items');
  final hasData = payload.containsKey('data');
  if (!hasItems && !hasData) {
    throw const FormatException('Response payload missing items/data list.');
  }

  final dynamic rawCollection = hasItems ? payload['items'] : payload['data'];
  if (rawCollection is! List) {
    throw const FormatException('Response items/data is not a list.');
  }

  final page = _toInt((meta is Map<String, dynamic>) ? meta['page'] : payload['page']) ?? fallback.page;
  final pageSize =
      _toInt((meta is Map<String, dynamic>) ? meta['pageSize'] : payload['pageSize']) ?? fallback.pageSize;
  final totalCount = _toInt(
        (meta is Map<String, dynamic>) ? meta['totalCount'] ?? meta['total'] : payload['totalCount'],
      ) ??
      rawCollection.length;

  return PaginatedResult(
    items: rawItems.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList(growable: false),
    page: page,
    pageSize: pageSize,
    totalCount: totalCount,
  );
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
