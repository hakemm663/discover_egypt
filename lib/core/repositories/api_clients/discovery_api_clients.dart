import 'package:dio/dio.dart';

import '../../api/generated/discovery_generated_api.dart';
import '../../config/app_config.dart';
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
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

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

class HotelsApiClient {
  HotelsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryGeneratedApi? sdk,
  })  : _httpClient = httpClient ?? DiscoveryHttpClient(),
        _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.hotels;

  Uri listUri({String? city, String? sortBy}) => _sdk.listHotelsUri(city, sortBy);

  Future<PaginatedResult<Map<String, dynamic>>> fetchHotels(
    PaginationQuery query,
  ) {
    return _fetchPaginatedWithFallback(
      httpClient: _httpClient,
      endpoint: endpoint,
      query: query,
      fallback: () => DiscoveryFallbackCatalog.fetchHotels(query),
    );
  }
}

class ToursApiClient {
  ToursApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryGeneratedApi? sdk,
  })  : _httpClient = httpClient ?? DiscoveryHttpClient(),
        _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.tours;

  Uri listUri({String? category}) => _sdk.listToursUri(category);

  Future<PaginatedResult<Map<String, dynamic>>> fetchTours(
    PaginationQuery query,
  ) {
    return _fetchPaginatedWithFallback(
      httpClient: _httpClient,
      endpoint: endpoint,
      query: query,
      fallback: () => DiscoveryFallbackCatalog.fetchTours(query),
    );
  }
}

class CarsApiClient {
  CarsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryGeneratedApi? sdk,
  })  : _httpClient = httpClient ?? DiscoveryHttpClient(),
        _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.cars;

  Uri listUri({String? type, bool? withDriverOnly}) =>
      _sdk.listCarsUri(type, withDriverOnly);

  Future<PaginatedResult<Map<String, dynamic>>> fetchCars(
    PaginationQuery query,
  ) {
    return _fetchPaginatedWithFallback(
      httpClient: _httpClient,
      endpoint: endpoint,
      query: query,
      fallback: () => DiscoveryFallbackCatalog.fetchCars(query),
    );
  }
}

class RestaurantsApiClient {
  RestaurantsApiClient({
    DiscoveryHttpClient? httpClient,
    DiscoveryGeneratedApi? sdk,
  })  : _httpClient = httpClient ?? DiscoveryHttpClient(),
        _sdk = sdk ?? const DiscoveryGeneratedApi();

  final DiscoveryHttpClient _httpClient;
  final DiscoveryGeneratedApi _sdk;

  String get endpoint => ApiEndpoints.restaurants;

  Uri listUri({String? cuisine}) => _sdk.listRestaurantsUri(cuisine);

  Future<PaginatedResult<Map<String, dynamic>>> fetchRestaurants(
    PaginationQuery query,
  ) {
    return _fetchPaginatedWithFallback(
      httpClient: _httpClient,
      endpoint: endpoint,
      query: query,
      fallback: () => DiscoveryFallbackCatalog.fetchRestaurants(query),
    );
  }
}

Future<PaginatedResult<Map<String, dynamic>>> _fetchPaginatedWithFallback({
  required DiscoveryHttpClient httpClient,
  required String endpoint,
  required PaginationQuery query,
  required PaginatedResult<Map<String, dynamic>> Function() fallback,
}) async {
  try {
    final payload = await httpClient.get(
      endpoint,
      queryParameters: _buildQueryParameters(query),
    );
    final result = _mapPaginated(payload, query);
    return result;
  } on DiscoveryApiException {
    if (AppConfig.isDiscoveryFallbackEnabled) {
      return fallback();
    }
    rethrow;
  } on FormatException catch (error) {
    if (AppConfig.isDiscoveryFallbackEnabled) {
      return fallback();
    }
    throw DiscoveryApiException(error.message);
  } on StateError catch (error) {
    if (AppConfig.isDiscoveryFallbackEnabled) {
      return fallback();
    }
    throw DiscoveryApiException(error.message);
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
  final List<dynamic> rawItems = switch (payload['items']) {
    final List<dynamic> items => items,
    _ => switch (payload['data']) {
        final List<dynamic> data => data,
        _ => const <dynamic>[],
      },
  };

  final page =
      _toInt((meta is Map<String, dynamic>) ? meta['page'] : payload['page']) ??
          fallback.page;
  final pageSize = _toInt(
        (meta is Map<String, dynamic>) ? meta['pageSize'] : payload['pageSize'],
      ) ??
      fallback.pageSize;
  final totalCount = _toInt(
        (meta is Map<String, dynamic>)
            ? meta['totalCount'] ?? meta['total']
            : payload['totalCount'],
      ) ??
      rawItems.length;

  return PaginatedResult<Map<String, dynamic>>(
    items: rawItems
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
