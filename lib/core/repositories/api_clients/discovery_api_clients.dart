export 'discovery_http_client.dart' show DiscoveryApiException, DiscoveryHttpClient;

import '../../constants/api_endpoints.dart';
import '../models/pagination_models.dart';
import 'discovery_fallback_catalog.dart';
import 'discovery_http_client.dart';

class HotelsApiClient {
  final DiscoveryHttpClient _httpClient;
  final DiscoveryFallbackCatalog _fallbackCatalog;

  HotelsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryFallbackCatalog? fallbackCatalog,
  }) : _httpClient = httpClient ?? DiscoveryHttpClient(),
       _fallbackCatalog = fallbackCatalog ?? const DiscoveryFallbackCatalog();

  String get endpoint => ApiEndpoints.hotels;

  Future<PaginatedResult<Map<String, dynamic>>> fetchHotels(
    PaginationQuery query,
  ) async {
    try {
      final payload = await _httpClient.get(
        endpoint,
        queryParameters: _buildQueryParameters(query),
      );
      return _mapPaginated(payload, query);
    } on DiscoveryApiException {
      return _fallbackCatalog.hotels(query);
    } on FormatException {
      return _fallbackCatalog.hotels(query);
    }
  }
}

class ToursApiClient {
  final DiscoveryHttpClient _httpClient;
  final DiscoveryFallbackCatalog _fallbackCatalog;

  ToursApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryFallbackCatalog? fallbackCatalog,
  }) : _httpClient = httpClient ?? DiscoveryHttpClient(),
       _fallbackCatalog = fallbackCatalog ?? const DiscoveryFallbackCatalog();

  String get endpoint => ApiEndpoints.tours;

  Future<PaginatedResult<Map<String, dynamic>>> fetchTours(
    PaginationQuery query,
  ) async {
    try {
      final payload = await _httpClient.get(
        endpoint,
        queryParameters: _buildQueryParameters(query),
      );
      return _mapPaginated(payload, query);
    } on DiscoveryApiException {
      return _fallbackCatalog.tours(query);
    } on FormatException {
      return _fallbackCatalog.tours(query);
    }
  }
}

class CarsApiClient {
  final DiscoveryHttpClient _httpClient;
  final DiscoveryFallbackCatalog _fallbackCatalog;

  CarsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryFallbackCatalog? fallbackCatalog,
  }) : _httpClient = httpClient ?? DiscoveryHttpClient(),
       _fallbackCatalog = fallbackCatalog ?? const DiscoveryFallbackCatalog();

  String get endpoint => ApiEndpoints.cars;

  Future<PaginatedResult<Map<String, dynamic>>> fetchCars(PaginationQuery query) async {
    try {
      final payload = await _httpClient.get(
        endpoint,
        queryParameters: _buildQueryParameters(query),
      );
      return _mapPaginated(payload, query);
    } on DiscoveryApiException {
      return _fallbackCatalog.cars(query);
    } on FormatException {
      return _fallbackCatalog.cars(query);
    }
  }
}

class RestaurantsApiClient {
  final DiscoveryHttpClient _httpClient;
  final DiscoveryFallbackCatalog _fallbackCatalog;

  RestaurantsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryFallbackCatalog? fallbackCatalog,
  }) : _httpClient = httpClient ?? DiscoveryHttpClient(),
       _fallbackCatalog = fallbackCatalog ?? const DiscoveryFallbackCatalog();

  String get endpoint => ApiEndpoints.restaurants;

  Future<PaginatedResult<Map<String, dynamic>>> fetchRestaurants(
    PaginationQuery query,
  ) async {
    try {
      final payload = await _httpClient.get(
        endpoint,
        queryParameters: _buildQueryParameters(query),
      );
      return _mapPaginated(payload, query);
    } on DiscoveryApiException {
      return _fallbackCatalog.restaurants(query);
    } on FormatException {
      return _fallbackCatalog.restaurants(query);
    }
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

  final hasItems = payload.containsKey('items');
  final hasData = payload.containsKey('data');
  if (!hasItems && !hasData) {
    throw const FormatException('Response payload missing items/data list.');
  }

  final dynamic rawCollection = hasItems ? payload['items'] : payload['data'];
  if (rawCollection is! List) {
    throw const FormatException('Response items/data is not a list.');
  }

  final page =
      _toInt((meta is Map<String, dynamic>) ? meta['page'] : payload['page']) ?? fallback.page;
  final pageSize =
      _toInt((meta is Map<String, dynamic>) ? meta['pageSize'] : payload['pageSize']) ??
      fallback.pageSize;
  final totalCount =
      _toInt(
        (meta is Map<String, dynamic>)
            ? meta['totalCount'] ?? meta['total']
            : payload['totalCount'],
      ) ??
      rawCollection.length;

  return PaginatedResult(
    items: rawCollection
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false),
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
