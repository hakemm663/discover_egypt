import 'package:dio/dio.dart';
import 'package:discover_egypt/core/constants/api_endpoints.dart';
import 'package:discover_egypt/core/repositories/api_clients/discovery_api_clients.dart';
import 'package:discover_egypt/core/repositories/models/pagination_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Discovery API clients', () {
    test('maps query filters and paginated payload for hotels', () async {
      RequestOptions? capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response(
                  requestOptions: options,
                  data: {
                    'items': [
                      {'id': 'h1', 'name': 'Hotel One'}
                    ],
                    'meta': {
                      'page': 2,
                      'pageSize': 5,
                      'totalCount': 9,
                    },
                  },
                ),
              );
            },
          ),
        );

      final client = HotelsApiClient(httpClient: DiscoveryHttpClient(dio: dio));
      final result = await client.fetchHotels(
        const PaginationQuery(
          page: 2,
          pageSize: 5,
          filters: {'city': 'Cairo', 'sortBy': 'Rating'},
        ),
      );

      expect(capturedOptions?.path, ApiEndpoints.hotels);
      expect(capturedOptions?.queryParameters['page'], 2);
      expect(capturedOptions?.queryParameters['pageSize'], 5);
      expect(capturedOptions?.queryParameters['city'], 'Cairo');
      expect(capturedOptions?.queryParameters['sortBy'], 'Rating');
      expect(result.items.first['id'], 'h1');
      expect(result.page, 2);
      expect(result.pageSize, 5);
      expect(result.totalCount, 9);
    });

    test('supports data-list payload fallback and default pagination', () async {
      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(
                  requestOptions: options,
                  data: {
                    'data': [
                      {'id': 'r1'}
                    ],
                  },
                ),
              );
            },
          ),
        );

      final client = RestaurantsApiClient(httpClient: DiscoveryHttpClient(dio: dio));
      final result = await client.fetchRestaurants(const PaginationQuery(page: 3, pageSize: 10));

      expect(result.items.first['id'], 'r1');
      expect(result.page, 3);
      expect(result.pageSize, 10);
      expect(result.totalCount, 1);
    });

    test('maps dio errors to discovery api exceptions', () async {
      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionTimeout,
                ),
              );
            },
          ),
        );

      final client = CarsApiClient(httpClient: DiscoveryHttpClient(dio: dio));

      expect(
        () => client.fetchCars(const PaginationQuery()),
        throwsA(
          isA<DiscoveryApiException>().having(
            (e) => e.message,
            'message',
            contains('No internet connection'),
          ),
        ),
      );
    });
  });
}
