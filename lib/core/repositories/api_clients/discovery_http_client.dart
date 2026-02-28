import 'package:dio/dio.dart';

import '../../constants/api_endpoints.dart';

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
      throw const DiscoveryApiException('Invalid server response shape.');
    } on DioException catch (error) {
      throw DiscoveryApiException(_mapDioError(error));
    } on DiscoveryApiException {
      rethrow;
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
