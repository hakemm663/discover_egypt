import '../../constants/api_endpoints.dart';

class UserSignals {
  final Set<String> bookmarkedHotelIds;
  final Set<String> bookmarkedCarIds;
  final Set<String> bookmarkedRestaurantIds;
  final Set<String> recentlyViewedTourIds;

  const UserSignals({
    required this.bookmarkedHotelIds,
    required this.bookmarkedCarIds,
    required this.bookmarkedRestaurantIds,
    required this.recentlyViewedTourIds,
  });
}

class DiscoveryFirestoreClient {
  String get endpoint => ApiEndpoints.firebaseBaseUrl;

  Future<UserSignals> fetchUserSignals({required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final signals = _demoSignals[userId] ?? _emptySignals;
    return UserSignals(
      bookmarkedHotelIds: signals.bookmarkedHotelIds,
      bookmarkedCarIds: signals.bookmarkedCarIds,
      bookmarkedRestaurantIds: signals.bookmarkedRestaurantIds,
      recentlyViewedTourIds: signals.recentlyViewedTourIds,
    );
  }
}

const _emptySignals = UserSignals(
  bookmarkedHotelIds: <String>{},
  bookmarkedCarIds: <String>{},
  bookmarkedRestaurantIds: <String>{},
  recentlyViewedTourIds: <String>{},
);

const _demoSignals = {
  'demo-user': UserSignals(
    bookmarkedHotelIds: {'2', '5'},
    bookmarkedCarIds: {'1'},
    bookmarkedRestaurantIds: {'2', '4'},
    recentlyViewedTourIds: {'1', '4'},
  ),
};
