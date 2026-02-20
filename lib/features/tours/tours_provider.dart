import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';

final toursProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    {
      'id': '1',
      'name': 'Pyramids & Sphinx Day Tour',
      'category': 'Historical',
      'duration': 'Full Day • 8 hours',
      'image': Img.pyramidsMain,
      'rating': 4.9,
      'reviewCount': 1250,
      'price': 65.0,
      'pickupIncluded': true,
    },
    {
      'id': '2',
      'name': 'Nile River Cruise',
      'category': 'Cruise',
      'duration': '3 Days • Luxor to Aswan',
      'image': Img.nileCruise,
      'rating': 4.8,
      'reviewCount': 890,
      'price': 320.0,
      'pickupIncluded': true,
    },
    {
      'id': '3',
      'name': 'Luxor Temple & Valley of Kings',
      'category': 'Historical',
      'duration': 'Full Day • 10 hours',
      'image': Img.luxorTemple,
      'rating': 4.7,
      'reviewCount': 720,
      'price': 85.0,
      'pickupIncluded': true,
    },
    {
      'id': '4',
      'name': 'Red Sea Diving Adventure',
      'category': 'Adventure',
      'duration': 'Half Day • 4 hours',
      'image': Img.coralReef,
      'rating': 4.9,
      'reviewCount': 540,
      'price': 95.0,
      'pickupIncluded': false,
    },
    {
      'id': '5',
      'name': 'Desert Safari & BBQ',
      'category': 'Adventure',
      'duration': 'Evening • 5 hours',
      'image': Img.pyramidsCamels,
      'rating': 4.6,
      'reviewCount': 380,
      'price': 75.0,
      'pickupIncluded': true,
    },
  ];
});
