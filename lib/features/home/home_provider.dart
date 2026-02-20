import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

class HomeData {
  final List<Map<String, dynamic>> hotels;
  final List<Map<String, dynamic>> tours;
  final List<Map<String, dynamic>> recommendedTours;
  final List<Map<String, dynamic>> destinations;

  const HomeData({
    required this.hotels,
    required this.tours,
    required this.recommendedTours,
    required this.destinations,
  });
}

final homeDataProvider = FutureProvider<HomeData>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  return HomeData(
    hotels: const [
      {
        'id': '1',
        'name': 'Pyramids View Hotel',
        'location': 'Giza, Cairo',
        'image': Img.hotelLuxury,
        'rating': 4.8,
        'reviewCount': 520,
        'price': 120.0,
      },
      {
        'id': '2',
        'name': 'Nile Ritz Carlton',
        'location': 'Downtown Cairo',
        'image': Img.hotelPool,
        'rating': 4.9,
        'reviewCount': 890,
        'price': 250.0,
      },
      {
        'id': '3',
        'name': 'Steigenberger Resort',
        'location': 'Hurghada',
        'image': Img.hotelResort,
        'rating': 4.7,
        'reviewCount': 430,
        'price': 180.0,
      },
    ],
    tours: const [
      {
        'id': '1',
        'name': 'Pyramids & Sphinx Day Tour',
        'duration': 'Full Day • 8 hours',
        'image': Img.pyramidsMain,
        'rating': 4.9,
        'reviewCount': 1250,
        'price': 65.0,
      },
      {
        'id': '2',
        'name': 'Nile River Cruise',
        'duration': 'Evening • 3 hours',
        'image': Img.nileCruise,
        'rating': 4.8,
        'reviewCount': 800,
        'price': 45.0,
      },
    ],
    recommendedTours: const [
      {
        'id': '4',
        'name': 'Desert Safari Adventure',
        'duration': 'Half Day • 4 hours',
        'image': Img.desertSafari,
        'rating': 4.8,
        'reviewCount': 300,
        'price': 50.0,
      },
      {
        'id': '5',
        'name': 'Alexandria City Tour',
        'duration': 'Full Day • 10 hours',
        'image': Img.alexandria,
        'rating': 4.7,
        'reviewCount': 200,
        'price': 75.0,
      },
    ],
    destinations: const [
      {'name': 'Pyramids of Giza', 'image': Img.pyramidsMain},
      {'name': 'Luxor Temple', 'image': Img.luxorTemple},
      {'name': 'Nile River', 'image': Img.nileRiver},
    ],
  );
});
