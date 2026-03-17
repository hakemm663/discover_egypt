import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/image_urls.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../domain/models/vendor_listing_draft.dart';

final vendorListingsProvider = StateNotifierProvider<
    VendorListingsNotifier, List<VendorListingDraft>>((ref) {
  return VendorListingsNotifier(Hive.box(AppConstants.cacheBox));
});

class VendorListingsNotifier extends StateNotifier<List<VendorListingDraft>> {
  VendorListingsNotifier(this._box) : super(const <VendorListingDraft>[]) {
    _load();
  }

  final Box<dynamic> _box;
  final Uuid _uuid = const Uuid();

  void _load() {
    final raw = _box.get(AppConstants.vendorListingsDraftsKey);
    if (raw is List) {
      state = raw
          .whereType<Map>()
          .map((entry) =>
              VendorListingDraft.fromJson(Map<String, dynamic>.from(entry)))
          .toList(growable: false);
      return;
    }

    state = <VendorListingDraft>[
      VendorListingDraft(
        id: 'vendor_apartment_luxor_loft',
        category: MarketplaceCategory.apartment,
        title: 'Luxor Loft with Temple Views',
        city: 'Luxor',
        location: 'West Bank, Luxor',
        description:
            'A design-forward apartment for long-stay travelers who want a quieter home base near the Valley of the Kings.',
        price: 110,
        vendorName: 'Nile Stay Collective',
        cancellationPolicy: 'Free cancellation up to 72 hours before check-in.',
        images: const <String>[Img.hotelRoom],
        tags: const <String>['Long stay', 'Temple views'],
        status: VendorListingStatus.pendingApproval,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
    _persist();
  }

  Future<void> saveDraft(VendorListingDraft draft) async {
    final nextDraft = draft.id.isEmpty
        ? draft.copyWith(
            id: _uuid.v4(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
        : draft.copyWith(updatedAt: DateTime.now());

    final existingIndex =
        state.indexWhere((listing) => listing.id == nextDraft.id);
    final nextState = [...state];
    if (existingIndex == -1) {
      nextState.insert(0, nextDraft);
    } else {
      nextState[existingIndex] = nextDraft;
    }
    state = nextState;
    await _persist();
  }

  Future<void> submitForReview(String id) async {
    state = state
        .map(
          (listing) => listing.id == id
              ? listing.copyWith(
                  status: VendorListingStatus.pendingApproval,
                  updatedAt: DateTime.now(),
                )
              : listing,
        )
        .toList(growable: false);
    await _persist();
  }

  Future<void> updateStatus(String id, VendorListingStatus status) async {
    state = state
        .map(
          (listing) => listing.id == id
              ? listing.copyWith(status: status, updatedAt: DateTime.now())
              : listing,
        )
        .toList(growable: false);
    await _persist();
  }

  VendorListingDraft? findById(String id) {
    for (final listing in state) {
      if (listing.id == id) return listing;
    }
    return null;
  }

  Future<void> _persist() async {
    await _box.put(
      AppConstants.vendorListingsDraftsKey,
      state.map((listing) => listing.toJson()).toList(growable: false),
    );
  }
}
