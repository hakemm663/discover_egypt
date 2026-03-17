import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/image_urls.dart';
import '../../../vendor/domain/models/vendor_listing_draft.dart';
import '../../../vendor/presentation/providers/vendor_dashboard_providers.dart';
import '../../domain/models/marketplace_listing.dart';

final marketplaceCatalogProvider = Provider<List<MarketplaceListing>>((ref) {
  final approvedVendorListings = ref
      .watch(vendorListingsProvider)
      .where((listing) => listing.status == VendorListingStatus.approved)
      .map((listing) => listing.toMarketplaceListing());

  return <MarketplaceListing>[
    ..._seedListings,
    ...approvedVendorListings,
  ]..sort((left, right) => right.rating.compareTo(left.rating));
});

final featuredMarketplaceListingsProvider =
    Provider<List<MarketplaceListing>>((ref) {
  return ref
      .watch(marketplaceCatalogProvider)
      .where((listing) => listing.featured)
      .toList(growable: false);
});

final marketplaceListingProvider =
    Provider.family<MarketplaceListing?, String>((ref, listingId) {
  for (final listing in ref.watch(marketplaceCatalogProvider)) {
    if (listing.id == listingId) {
      return listing;
    }
  }
  return null;
});

final favoriteListingIdsProvider =
    StateNotifierProvider<FavoriteListingsNotifier, Set<String>>((ref) {
  return FavoriteListingsNotifier(Hive.box(AppConstants.cacheBox));
});

class FavoriteListingsNotifier extends StateNotifier<Set<String>> {
  FavoriteListingsNotifier(this._box) : super(const <String>{}) {
    _load();
  }

  final Box<dynamic> _box;

  void _load() {
    final raw = _box.get(AppConstants.favoriteListingIdsKey);
    if (raw is List) {
      state = raw.map((entry) => entry.toString()).toSet();
    }
  }

  Future<void> toggle(String listingId) async {
    final nextState = Set<String>.from(state);
    if (!nextState.add(listingId)) {
      nextState.remove(listingId);
    }
    state = nextState;
    await _box.put(
      AppConstants.favoriteListingIdsKey,
      nextState.toList(growable: false),
    );
  }
}

const List<MarketplaceListing> _seedListings = <MarketplaceListing>[
  MarketplaceListing(
    id: 'market_hotel_giza_reserve',
    category: MarketplaceCategory.hotel,
    title: 'Giza Reserve Hotel',
    location: 'Pyramids Plateau, Giza',
    city: 'Giza',
    description:
        'Boutique luxury hotel with sunrise pyramid views, airport pickup, and curated desert dinner experiences.',
    images: <String>[Img.hotelLuxury, Img.hotelPool],
    price: 240,
    rating: 4.9,
    reviewCount: 1280,
    cancellationPolicy: 'Free cancellation up to 48 hours before arrival.',
    vendorName: 'Pharaoh Hospitality Group',
    tags: <String>['Breakfast included', 'Airport pickup'],
    featured: true,
  ),
  MarketplaceListing(
    id: 'market_apartment_zamalek_suite',
    category: MarketplaceCategory.apartment,
    title: 'Zamalek Design Suite',
    location: 'Zamalek, Cairo',
    city: 'Cairo',
    description:
        'Quiet apartment for city explorers with concierge check-in, cowork corner, and a curated neighborhood guide.',
    images: <String>[Img.hotelRoom],
    price: 135,
    rating: 4.7,
    reviewCount: 430,
    cancellationPolicy: 'Free cancellation up to 5 days before arrival.',
    vendorName: 'Cairo Stays',
    tags: <String>['Self check-in', 'Long stay'],
    featured: true,
  ),
  MarketplaceListing(
    id: 'market_tour_luxor_private',
    category: MarketplaceCategory.tour,
    title: 'Private Luxor East & West Bank Tour',
    location: 'Luxor Temple pickup',
    city: 'Luxor',
    description:
        'A private full-day tour with a licensed Egyptologist, flexible pacing, and lunch by the Nile.',
    images: <String>[Img.luxorTemple, Img.valleyOfKings],
    price: 89,
    rating: 4.9,
    reviewCount: 780,
    cancellationPolicy: 'Free cancellation up to 24 hours before departure.',
    vendorName: 'Golden Nile Experiences',
    tags: <String>['Private guide', 'Lunch'],
    featured: true,
  ),
  MarketplaceListing(
    id: 'market_car_cairo_driver',
    category: MarketplaceCategory.car,
    title: 'Executive SUV with Driver',
    location: 'Downtown Cairo',
    city: 'Cairo',
    description:
        'Professional chauffeur service for airport runs, city itineraries, and intercity transfers.',
    images: <String>[Img.carSuv],
    price: 95,
    rating: 4.8,
    reviewCount: 210,
    cancellationPolicy: 'Free cancellation up to 12 hours before pickup.',
    vendorName: 'Delta Mobility',
    tags: <String>['With driver', 'Family friendly'],
  ),
  MarketplaceListing(
    id: 'market_guide_aswan_storyteller',
    category: MarketplaceCategory.guide,
    title: 'Aswan Storyteller Guide',
    location: 'Aswan Corniche',
    city: 'Aswan',
    description:
        'Local guide focused on Nubian culture, history, and flexible half-day experiences for independent travelers.',
    images: <String>[Img.philaeTemple],
    price: 55,
    rating: 4.8,
    reviewCount: 118,
    cancellationPolicy: 'Free cancellation up to 24 hours before meetup.',
    vendorName: 'Nubia Local Guides',
    tags: <String>['Arabic & English', 'Culture'],
  ),
  MarketplaceListing(
    id: 'market_attraction_abu_simbel',
    category: MarketplaceCategory.attraction,
    title: 'Abu Simbel Entry + Transfer',
    location: 'Abu Simbel, Aswan',
    city: 'Aswan',
    description:
        'Timed-entry attraction ticket bundle with round-trip transport and a short guided orientation on arrival.',
    images: <String>[Img.abuSimbel],
    price: 72,
    rating: 4.9,
    reviewCount: 500,
    cancellationPolicy: 'Non-refundable within 72 hours of entry.',
    vendorName: 'Heritage Access Egypt',
    tags: <String>['Ticket included', 'Transfer'],
    featured: true,
  ),
  MarketplaceListing(
    id: 'market_restaurant_nile_table',
    category: MarketplaceCategory.restaurant,
    title: 'Nile Table Rooftop',
    location: 'Garden City, Cairo',
    city: 'Cairo',
    description:
        'A modern Egyptian rooftop restaurant with sunset river views, tasting menus, and live oud sessions.',
    images: <String>[Img.restaurantInterior, Img.egyptianFood],
    price: 38,
    rating: 4.6,
    reviewCount: 960,
    cancellationPolicy:
        'Reservations can be cancelled up to 4 hours before dining.',
    vendorName: 'Nile Table Hospitality',
    tags: <String>['Rooftop', 'Fine dining'],
  ),
];
