import 'package:discover_egypt/core/repositories/firestore/discovery_firestore_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiscoveryFirestoreClient.fromFirestoreData', () {
    test('maps bookmark fields and recently viewed tours', () {
      final signals = DiscoveryFirestoreClient.fromFirestoreData(
        bookmarksData: {
          DiscoveryFirestoreClient.bookmarkedHotelIdsField: ['h1', 'h2', 7],
          DiscoveryFirestoreClient.bookmarkedCarIdsField: ['c1'],
          DiscoveryFirestoreClient.bookmarkedRestaurantIdsField: ['r1', 'r2'],
          DiscoveryFirestoreClient.recentlyViewedTourIdsField: ['t1', 't2'],
        },
        recentlyViewedTours: const [
          {'tourId': 't3'},
          {'tourId': 't4'},
        ],
      );

      expect(signals.bookmarkedHotelIds, {'h1', 'h2'});
      expect(signals.bookmarkedCarIds, {'c1'});
      expect(signals.bookmarkedRestaurantIds, {'r1', 'r2'});
      expect(signals.recentlyViewedTourIds, {'t1', 't2', 't3', 't4'});
    });

    test('provides empty defaults for missing and invalid values', () {
      final signals = DiscoveryFirestoreClient.fromFirestoreData(
        bookmarksData: {
          DiscoveryFirestoreClient.bookmarkedHotelIdsField: null,
          DiscoveryFirestoreClient.bookmarkedCarIdsField: 'invalid',
        },
        recentlyViewedTours: const [
          {'tourId': 42},
          {'unexpected': 'shape'},
        ],
      );

      expect(signals.bookmarkedHotelIds, isEmpty);
      expect(signals.bookmarkedCarIds, isEmpty);
      expect(signals.bookmarkedRestaurantIds, isEmpty);
      expect(signals.recentlyViewedTourIds, isEmpty);
    });
  });
}
