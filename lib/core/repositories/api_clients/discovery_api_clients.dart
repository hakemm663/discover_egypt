import '../../constants/api_endpoints.dart';
import '../models/pagination_models.dart';
import 'discovery_http_client.dart';

export 'discovery_http_client.dart' show DiscoveryApiException, DiscoveryHttpClient;

class HotelsApiClient {
  HotelsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  final DiscoveryHttpClient _httpClient;

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
  ToursApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  final DiscoveryHttpClient _httpClient;

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
  CarsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  final DiscoveryHttpClient _httpClient;

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
  RestaurantsApiClient({DiscoveryHttpClient? httpClient})
      : _httpClient = httpClient ?? DiscoveryHttpClient();

  final DiscoveryHttpClient _httpClient;

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

  final rawItems = rawCollection;
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

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
