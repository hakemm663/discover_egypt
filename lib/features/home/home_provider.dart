import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../shared/models/catalog_models.dart';

class HomeData {
  final List<HotelListItem> hotels;
  final List<TourListItem> tours;
  final List<TourListItem> recommendedTours;
  final List<DestinationItem> destinations;

  const HomeData({
    required this.hotels,
    required this.tours,
    required this.recommendedTours,
    required this.destinations,
  });
}

final homeDataProvider = FutureProvider<HomeData>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  return const HomeData(
    hotels: <HotelListItem>[
      HotelListItem(
        id: '1',
        name: 'Pyramids View Hotel',
        city: 'Cairo',
        location: 'Giza, Cairo',
        image: Img.hotelLuxury,
        rating: 4.8,
        reviewCount: 520,
        price: 120.0,
        stars: 5,
      ),
      HotelListItem(
        id: '2',
        name: 'Nile Ritz Carlton',
        city: 'Cairo',
        location: 'Downtown Cairo',
        image: Img.hotelPool,
        rating: 4.9,
        reviewCount: 890,
        price: 250.0,
        stars: 5,
      ),
      HotelListItem(
        id: '3',
        name: 'Steigenberger Resort',
        city: 'Hurghada',
        location: 'Hurghada',
        image: Img.hotelResort,
        rating: 4.7,
        reviewCount: 430,
        price: 180.0,
        stars: 5,
      ),
    ],
    tours: <TourListItem>[
      TourListItem(
        id: '1',
        name: 'Pyramids & Sphinx Day Tour',
        category: 'Historical',
        duration: 'Full Day • 8 hours',
        image: Img.pyramidsMain,
        rating: 4.9,
        reviewCount: 1250,
        price: 65.0,
        pickupIncluded: true,
      ),
      TourListItem(
        id: '2',
        name: 'Nile River Cruise',
        category: 'Cruise',
        duration: 'Evening • 3 hours',
        image: Img.nileCruise,
        rating: 4.8,
        reviewCount: 800,
        price: 45.0,
        pickupIncluded: true,
      ),
    ],
    recommendedTours: <TourListItem>[
      TourListItem(
        id: '4',
        name: 'Desert Safari Adventure',
        category: 'Adventure',
        duration: 'Half Day • 4 hours',
        image: Img.desertSafari,
        rating: 4.8,
        reviewCount: 300,
        price: 50.0,
        pickupIncluded: false,
      ),
      TourListItem(
        id: '5',
        name: 'Alexandria City Tour',
        category: 'Cultural',
        duration: 'Full Day • 10 hours',
        image: Img.alexandria,
        rating: 4.7,
        reviewCount: 200,
        price: 75.0,
        pickupIncluded: true,
      ),
    ],
    destinations: <DestinationItem>[
      DestinationItem(name: 'Pyramids of Giza', image: Img.pyramidsMain),
      DestinationItem(name: 'Luxor Temple', image: Img.luxorTemple),
      DestinationItem(name: 'Nile River', image: Img.nileRiver),
    ],
  );
});

final homeHotelsProvider = Provider<List<HotelListItem>>((ref) {
  return ref.watch(homeDataProvider.select((value) => value.valueOrNull?.hotels ?? const <HotelListItem>[]));
});

final homeToursProvider = Provider<List<TourListItem>>((ref) {
  return ref.watch(homeDataProvider.select((value) => value.valueOrNull?.tours ?? const <TourListItem>[]));
});

final homeRecommendedToursProvider = Provider<List<TourListItem>>((ref) {
  return ref.watch(homeDataProvider.select((value) => value.valueOrNull?.recommendedTours ?? const <TourListItem>[]));
});

final homeDestinationsProvider = Provider<List<DestinationItem>>((ref) {
  return ref.watch(homeDataProvider.select((value) => value.valueOrNull?.destinations ?? const <DestinationItem>[]));
});
