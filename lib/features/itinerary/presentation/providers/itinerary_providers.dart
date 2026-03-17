import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/models/itinerary_entry.dart';

final itineraryEntriesProvider =
    StateNotifierProvider<ItineraryEntriesNotifier, List<ItineraryEntry>>(
  (ref) => ItineraryEntriesNotifier(Hive.box(AppConstants.cacheBox)),
);

class ItineraryEntriesNotifier extends StateNotifier<List<ItineraryEntry>> {
  ItineraryEntriesNotifier(this._box) : super(const <ItineraryEntry>[]) {
    _load();
  }

  final Box<dynamic> _box;

  void _load() {
    final raw = _box.get(AppConstants.itineraryDraftEntriesKey);
    if (raw is List) {
      state = raw
          .whereType<Map>()
          .map(
            (entry) => ItineraryEntry.fromJson(Map<String, dynamic>.from(entry)),
          )
          .toList(growable: false);
    }
  }

  Future<void> addListing(String listingId) async {
    if (state.any((entry) => entry.listingId == listingId)) {
      return;
    }

    final nextDay = state.isEmpty
        ? 1
        : state
                .map((entry) => entry.day)
                .reduce((left, right) => left > right ? left : right) +
            1;
    state = [
      ...state,
      ItineraryEntry(listingId: listingId, day: nextDay),
    ];
    await _persist();
  }

  Future<void> removeListing(String listingId) async {
    state = state
        .where((entry) => entry.listingId != listingId)
        .toList(growable: false);
    await _persist();
  }

  Future<void> _persist() async {
    await _box.put(
      AppConstants.itineraryDraftEntriesKey,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }
}
