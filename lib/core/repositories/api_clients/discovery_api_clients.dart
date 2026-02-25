import 'package:dio/dio.dart';

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
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

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

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
