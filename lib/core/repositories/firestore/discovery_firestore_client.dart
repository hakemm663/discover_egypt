import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';
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
  DiscoveryFirestoreClient({FirebaseFirestore? firestore})
      : _firestoreOverride = firestore;

  static const String signalsCollection = 'signals';
  static const String bookmarksDocument = 'bookmarks';
  static const String recentlyViewedToursDocument = 'recently_viewed_tours';
  static const String recentlyViewedToursItemsCollection = 'items';

  static const String bookmarkedHotelIdsField = 'bookmarkedHotelIds';
  static const String bookmarkedCarIdsField = 'bookmarkedCarIds';
  static const String bookmarkedRestaurantIdsField = 'bookmarkedRestaurantIds';
  static const String recentlyViewedTourIdsField = 'recentlyViewedTourIds';

  final FirebaseFirestore? _firestoreOverride;

  String get endpoint => ApiEndpoints.firebaseBaseUrl;

  Future<UserSignals> fetchUserSignals({required String userId}) async {
    final firestore = _firestoreOverride ?? FirebaseFirestore.instance;

    final userSignalsCollection = firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(signalsCollection);

    final bookmarksDocumentSnapshot =
        await userSignalsCollection.doc(bookmarksDocument).get();
    final recentTourSnapshots = await userSignalsCollection
        .doc(recentlyViewedToursDocument)
        .collection(recentlyViewedToursItemsCollection)
        .orderBy('lastViewedAt', descending: true)
        .limit(40)
        .get();

    return fromFirestoreData(
      bookmarksData: bookmarksDocumentSnapshot.data(),
      recentlyViewedTours: recentTourSnapshots.docs.map((doc) => doc.data()),
    );
  }

  static UserSignals fromFirestoreData({
    Map<String, dynamic>? bookmarksData,
    Iterable<Map<String, dynamic>> recentlyViewedTours =
        const <Map<String, dynamic>>[],
  }) {
    final normalizedBookmarks = bookmarksData ?? const <String, dynamic>{};
    final recentTourIdsFromCollection = recentlyViewedTours
        .map((doc) => doc['tourId'])
        .whereType<String>()
        .toSet();

    final recentTourIdsFromDocument = _stringSetFromDynamic(
      normalizedBookmarks[recentlyViewedTourIdsField],
    );

    return UserSignals(
      bookmarkedHotelIds: _stringSetFromDynamic(
        normalizedBookmarks[bookmarkedHotelIdsField],
      ),
      bookmarkedCarIds: _stringSetFromDynamic(
        normalizedBookmarks[bookmarkedCarIdsField],
      ),
      bookmarkedRestaurantIds: _stringSetFromDynamic(
        normalizedBookmarks[bookmarkedRestaurantIdsField],
      ),
      recentlyViewedTourIds: {
        ...recentTourIdsFromDocument,
        ...recentTourIdsFromCollection,
      },
    );
  }

  static Set<String> _stringSetFromDynamic(dynamic rawValue) {
    if (rawValue is Iterable) {
      return rawValue.whereType<String>().toSet();
    }

    return <String>{};
  }
}
